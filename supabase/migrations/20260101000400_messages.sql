-- Messages, attachments, reactions, read receipts, pins, cloud drafts.
-- The client generates message ids (UUID) so sends are idempotent (safe to retry).
-- Column-level grants + guard triggers make server-controlled fields (status, created_at,
-- edited_at, deleted_at, sender, conversation) impossible to forge from the client.

create table public.messages (
  id uuid primary key,
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  sender_id uuid not null references public.profiles (id),
  type public.message_type not null default 'text',
  text text,
  reply_to_id uuid references public.messages (id) on delete set null,
  forwarded_from_id uuid references public.messages (id) on delete set null,
  status public.message_status not null default 'sent',
  created_at timestamptz not null default now(),
  edited_at timestamptz,
  deleted_at timestamptz,
  constraint messages_text_len check (text is null or char_length(text) <= 4096),
  constraint messages_text_required check (
    type <> 'text' or deleted_at is not null or (text is not null and char_length(btrim(text)) > 0)
  )
);
create index messages_conversation_created_idx on public.messages (conversation_id, created_at desc, id);
create index messages_reply_idx on public.messages (reply_to_id) where reply_to_id is not null;

alter table public.conversations
  add constraint conversations_last_message_fk
  foreign key (last_message_id) references public.messages (id) on delete set null;

create table public.message_attachments (
  id uuid primary key,
  message_id uuid not null references public.messages (id) on delete cascade,
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  kind public.attachment_kind not null,
  storage_path text not null,
  mime_type text not null check (char_length(mime_type) <= 127),
  size_bytes bigint not null check (size_bytes > 0),
  width integer check (width is null or width > 0),
  height integer check (height is null or height > 0),
  duration_ms integer check (duration_ms is null or duration_ms >= 0),
  created_at timestamptz not null default now(),
  -- files are stored as "<conversation id>/<upload id>/<name>" in the private chat-media bucket
  constraint attachments_path_prefix check (storage_path like conversation_id::text || '/%')
);
create index message_attachments_message_idx on public.message_attachments (message_id);
create index message_attachments_conversation_idx on public.message_attachments (conversation_id);

create table public.message_reactions (
  message_id uuid not null references public.messages (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  emoji text not null check (char_length(emoji) between 1 and 16),
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (message_id, user_id, emoji)
);
create index message_reactions_conversation_idx on public.message_reactions (conversation_id);

create table public.message_reads (
  message_id uuid not null references public.messages (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  read_at timestamptz not null default now(),
  primary key (message_id, user_id)
);
create index message_reads_conversation_idx on public.message_reads (conversation_id, user_id);

create table public.message_pins (
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  message_id uuid not null references public.messages (id) on delete cascade,
  pinned_by uuid not null references public.profiles (id),
  pinned_at timestamptz not null default now(),
  primary key (conversation_id, message_id)
);

create table public.message_drafts (
  user_id uuid not null references public.profiles (id) on delete cascade,
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  text text not null check (char_length(text) <= 4096),
  reply_to_id uuid references public.messages (id) on delete set null,
  updated_at timestamptz not null default now(),
  primary key (user_id, conversation_id)
);

-- ---------- triggers ----------

-- Validates a new message (reply target must be in the same conversation).
create function public.messages_before_insert() returns trigger
language plpgsql set search_path = '' as $$
begin
  if new.reply_to_id is not null and not exists (
    select 1 from public.messages r where r.id = new.reply_to_id and r.conversation_id = new.conversation_id
  ) then
    raise exception 'reply target is not in this conversation' using errcode = '23514';
  end if;
  return new;
end $$;
create trigger messages_before_insert before insert on public.messages
  for each row execute function public.messages_before_insert();

-- Immutable columns, server-owned columns, and soft-delete semantics.
create function public.messages_before_update() returns trigger
language plpgsql set search_path = '' as $$
begin
  if new.id is distinct from old.id
     or new.conversation_id is distinct from old.conversation_id
     or new.sender_id is distinct from old.sender_id
     or new.type is distinct from old.type
     or new.created_at is distinct from old.created_at
     or new.reply_to_id is distinct from old.reply_to_id
     or new.forwarded_from_id is distinct from old.forwarded_from_id then
    raise exception 'immutable message column' using errcode = '42501';
  end if;

  -- Only server-side code (read-receipt trigger, service role) may change status.
  if current_user in ('anon', 'authenticated') then
    new.status := old.status;
  end if;

  if new.deleted_at is not null and old.deleted_at is null then
    -- Soft delete: tombstone the row (so realtime can tell clients) and drop its content.
    new.deleted_at := now();
    new.text := null;
    new.edited_at := old.edited_at;
  elsif old.deleted_at is not null then
    new.deleted_at := old.deleted_at;
    new.text := old.text;
    new.edited_at := old.edited_at;
  elsif new.text is distinct from old.text then
    new.edited_at := now();
  else
    new.edited_at := old.edited_at;
  end if;
  return new;
end $$;
create trigger messages_before_update before update on public.messages
  for each row execute function public.messages_before_update();

-- Soft delete also removes the message's attachments, reactions and pins. This runs as the
-- function owner (SECURITY DEFINER) because clients have no DELETE privilege on those tables.
-- Files in storage are cleaned up by a scheduled job (not part of this migration).
create function public.messages_after_soft_delete() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  delete from public.message_attachments where message_id = new.id;
  delete from public.message_reactions where message_id = new.id;
  delete from public.message_pins where message_id = new.id;
  return new;
end $$;
create trigger messages_after_soft_delete after update of deleted_at on public.messages
  for each row when (new.deleted_at is not null and old.deleted_at is null)
  execute function public.messages_after_soft_delete();

-- Keeps conversations.last_message_* fresh for the chat list.
create function public.messages_after_insert() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  update public.conversations
     set last_message_id = new.id, last_message_at = new.created_at
   where id = new.conversation_id
     and (last_message_at is null or new.created_at >= last_message_at);
  return new;
end $$;
create trigger messages_after_insert after insert on public.messages
  for each row execute function public.messages_after_insert();

-- Denormalise conversation_id onto child rows (enables realtime filters + simple RLS).
create function public.child_fill_conversation() returns trigger
language plpgsql security definer set search_path = '' as $$
declare v_conversation uuid;
begin
  select conversation_id into v_conversation from public.messages where id = new.message_id;
  if v_conversation is null then
    raise exception 'message not found' using errcode = '23503';
  end if;
  new.conversation_id := v_conversation;
  return new;
end $$;
create trigger message_attachments_fill before insert on public.message_attachments
  for each row execute function public.child_fill_conversation();
create trigger message_reactions_fill before insert on public.message_reactions
  for each row execute function public.child_fill_conversation();
create trigger message_reads_fill before insert on public.message_reads
  for each row execute function public.child_fill_conversation();

-- Child rows may not be re-parented.
create function public.child_immutable_parent() returns trigger
language plpgsql set search_path = '' as $$
begin
  if new.message_id is distinct from old.message_id
     or new.conversation_id is distinct from old.conversation_id then
    raise exception 'immutable message reference' using errcode = '42501';
  end if;
  return new;
end $$;
create trigger message_attachments_immutable before update on public.message_attachments
  for each row execute function public.child_immutable_parent();
create trigger message_reactions_immutable before update on public.message_reactions
  for each row execute function public.child_immutable_parent();
create trigger message_reads_immutable before update on public.message_reads
  for each row execute function public.child_immutable_parent();

-- Read time is always server time; read receipts honour the reader's privacy setting.
create function public.message_reads_before_write() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.read_at := now();
  return new;
end $$;
create trigger message_reads_time before insert or update on public.message_reads
  for each row execute function public.message_reads_before_write();

create function public.message_reads_after_insert() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  update public.conversation_members
     set last_read_at = greatest(coalesce(last_read_at, '-infinity'::timestamptz), new.read_at)
   where conversation_id = new.conversation_id and user_id = new.user_id;

  -- In direct chats, tell the sender their message was read (unless the reader disabled receipts).
  update public.messages m
     set status = 'read'
   where m.id = new.message_id
     and m.sender_id <> new.user_id
     and m.status = 'sent'
     and exists (select 1 from public.conversations c where c.id = m.conversation_id and c.type = 'direct')
     and coalesce((select s.read_receipts_enabled from public.user_settings s where s.user_id = new.user_id), true);
  return new;
end $$;
create trigger message_reads_after_insert after insert on public.message_reads
  for each row execute function public.message_reads_after_insert();

create trigger message_drafts_updated_at before update on public.message_drafts
  for each row execute function public.set_updated_at();

revoke execute on function
  public.messages_before_insert(), public.messages_before_update(), public.messages_after_insert(),
  public.messages_after_soft_delete(),
  public.child_fill_conversation(), public.child_immutable_parent(),
  public.message_reads_before_write(), public.message_reads_after_insert()
from public, anon, authenticated;

-- ---------- RLS + column-level grants ----------
alter table public.messages enable row level security;
alter table public.message_attachments enable row level security;
alter table public.message_reactions enable row level security;
alter table public.message_reads enable row level security;
alter table public.message_pins enable row level security;
alter table public.message_drafts enable row level security;

-- messages: no hard deletes from clients (use soft delete); clients cannot set status/created_at.
revoke all on public.messages from authenticated;
grant select on public.messages to authenticated;
grant insert (id, conversation_id, sender_id, type, text, reply_to_id) on public.messages to authenticated;
grant update (id, conversation_id, sender_id, type, text, reply_to_id, edited_at, deleted_at)
  on public.messages to authenticated;

create policy messages_select on public.messages for select to authenticated
  using (public.is_conversation_member(conversation_id));
create policy messages_insert on public.messages for insert to authenticated
  with check (
    sender_id = (select auth.uid())
    and type <> 'system'
    and public.can_post_in_conversation(conversation_id)
  );
create policy messages_update_own on public.messages for update to authenticated
  using (sender_id = (select auth.uid()) and deleted_at is null)
  with check (sender_id = (select auth.uid()) and public.can_post_in_conversation(conversation_id));

revoke all on public.message_attachments from authenticated;
grant select on public.message_attachments to authenticated;
grant insert (id, message_id, kind, storage_path, mime_type, size_bytes, width, height, duration_ms)
  on public.message_attachments to authenticated;
grant update (id, message_id, kind, storage_path, mime_type, size_bytes, width, height, duration_ms)
  on public.message_attachments to authenticated;
create policy attachments_select on public.message_attachments for select to authenticated
  using (public.is_conversation_member(conversation_id));
create policy attachments_insert on public.message_attachments for insert to authenticated
  with check (
    exists (select 1 from public.messages m where m.id = message_id and m.sender_id = (select auth.uid()))
    and public.can_post_in_conversation(conversation_id)
  );
create policy attachments_update_own on public.message_attachments for update to authenticated
  using (exists (select 1 from public.messages m where m.id = message_id and m.sender_id = (select auth.uid())))
  with check (exists (select 1 from public.messages m where m.id = message_id and m.sender_id = (select auth.uid())));

revoke all on public.message_reactions from authenticated;
grant select, delete on public.message_reactions to authenticated;
grant insert (message_id, user_id, emoji) on public.message_reactions to authenticated;
grant update (message_id, user_id, emoji) on public.message_reactions to authenticated;
create policy reactions_select on public.message_reactions for select to authenticated
  using (public.is_conversation_member(conversation_id));
create policy reactions_insert on public.message_reactions for insert to authenticated
  with check (user_id = (select auth.uid()) and public.is_conversation_member(conversation_id));
create policy reactions_update_own on public.message_reactions for update to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy reactions_delete_own on public.message_reactions for delete to authenticated
  using (user_id = (select auth.uid()));

revoke all on public.message_reads from authenticated;
grant select on public.message_reads to authenticated;
grant insert (message_id, user_id, read_at) on public.message_reads to authenticated;
grant update (message_id, user_id, read_at) on public.message_reads to authenticated;
create policy reads_select on public.message_reads for select to authenticated
  using (public.is_conversation_member(conversation_id));
create policy reads_insert on public.message_reads for insert to authenticated
  with check (user_id = (select auth.uid()) and public.is_conversation_member(conversation_id));
create policy reads_update_own on public.message_reads for update to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

revoke all on public.message_pins from authenticated;
grant select, insert, delete on public.message_pins to authenticated;
create policy pins_select on public.message_pins for select to authenticated
  using (public.is_conversation_member(conversation_id));
create policy pins_insert on public.message_pins for insert to authenticated
  with check (
    pinned_by = (select auth.uid())
    and public.can_post_in_conversation(conversation_id)
    and exists (select 1 from public.messages m where m.id = message_id and m.conversation_id = message_pins.conversation_id)
  );
create policy pins_delete on public.message_pins for delete to authenticated
  using (public.can_post_in_conversation(conversation_id));

revoke all on public.message_drafts from authenticated;
grant select, insert, delete on public.message_drafts to authenticated;
grant update (text, reply_to_id) on public.message_drafts to authenticated;
create policy drafts_own on public.message_drafts for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()) and public.is_conversation_member(conversation_id));

-- ---------- Realtime ----------
-- Realtime evaluates RLS per subscriber, so members only receive their own conversations' events.
alter publication supabase_realtime add table
  public.messages, public.message_attachments, public.message_reactions,
  public.conversations, public.conversation_members;
