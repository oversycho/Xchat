-- Conversations (direct / saved / group / channel), membership, folders.
-- "Saved messages" is a `saved` conversation with a single member (no separate table needed).
-- Group/channel specifics (permissions, invite links, ...) arrive in a later migration.

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  type public.conversation_type not null,
  -- direct: "<smaller uid>:<larger uid>", saved: "saved:<uid>"; guarantees one row per pair.
  direct_key text unique,
  created_by uuid references public.profiles (id),
  last_message_id uuid,
  last_message_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint conversations_key_matches_type check ((type in ('direct', 'saved')) = (direct_key is not null))
);
create trigger conversations_updated_at before update on public.conversations
  for each row execute function public.set_updated_at();

create table public.conversation_members (
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  role public.member_role not null default 'member',
  joined_at timestamptz not null default now(),
  left_at timestamptz,
  pinned_at timestamptz,
  muted_until timestamptz,
  archived_at timestamptz,
  last_read_at timestamptz,
  primary key (conversation_id, user_id)
);
create index conversation_members_user_idx on public.conversation_members (user_id) where left_at is null;

create table public.chat_folders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  name text not null check (char_length(name) between 1 and 32),
  position integer not null default 0,
  created_at timestamptz not null default now()
);
create index chat_folders_user_idx on public.chat_folders (user_id);

create table public.chat_folder_items (
  folder_id uuid not null references public.chat_folders (id) on delete cascade,
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  primary key (folder_id, conversation_id)
);

-- ---------- helpers used by RLS (SECURITY DEFINER avoids policy recursion) ----------
create function public.is_conversation_member(p_conversation_id uuid) returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.conversation_members m
    where m.conversation_id = p_conversation_id
      and m.user_id = (select auth.uid())
      and m.left_at is null
  )
$$;

-- Membership + role + block rules for posting. Channels: admins only. Direct: no blocks either way.
create function public.can_post_in_conversation(p_conversation_id uuid) returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (
    select 1
    from public.conversation_members m
    join public.conversations c on c.id = m.conversation_id
    where m.conversation_id = p_conversation_id
      and m.user_id = (select auth.uid())
      and m.left_at is null
      and case c.type
        when 'channel' then m.role in ('owner', 'admin')
        when 'direct' then not exists (
          select 1
          from public.conversation_members other
          where other.conversation_id = c.id
            and other.user_id <> m.user_id
            and public.is_blocked_between(m.user_id, other.user_id)
        )
        else m.role <> 'subscriber'
      end
  )
$$;

revoke execute on function public.is_conversation_member(uuid) from public, anon;
revoke execute on function public.can_post_in_conversation(uuid) from public, anon;
grant execute on function public.is_conversation_member(uuid) to authenticated;
grant execute on function public.can_post_in_conversation(uuid) to authenticated;

-- ---------- RPCs (the only way clients create conversations) ----------
create function public.get_or_create_direct_conversation(p_other_user_id uuid) returns uuid
language plpgsql security definer set search_path = '' as $$
declare
  v_me uuid := (select auth.uid());
  v_key text;
  v_id uuid;
begin
  if v_me is null then
    raise exception 'not authenticated' using errcode = '28000';
  end if;
  if p_other_user_id is null or p_other_user_id = v_me then
    raise exception 'invalid user' using errcode = '22023';
  end if;
  if not exists (select 1 from public.profiles where id = p_other_user_id and deleted_at is null) then
    raise exception 'user not found' using errcode = 'P0002';
  end if;
  if public.is_blocked_between(v_me, p_other_user_id) then
    raise exception 'blocked' using errcode = '42501';
  end if;

  v_key := least(v_me::text, p_other_user_id::text) || ':' || greatest(v_me::text, p_other_user_id::text);

  select id into v_id from public.conversations where direct_key = v_key;
  if v_id is null then
    insert into public.conversations (type, direct_key, created_by)
    values ('direct', v_key, v_me)
    on conflict (direct_key) do nothing
    returning id into v_id;

    if v_id is null then -- lost a race with the other participant
      select id into v_id from public.conversations where direct_key = v_key;
    else
      insert into public.conversation_members (conversation_id, user_id)
      values (v_id, v_me), (v_id, p_other_user_id);
    end if;
  end if;
  return v_id;
end $$;

create function public.get_or_create_saved_conversation() returns uuid
language plpgsql security definer set search_path = '' as $$
declare
  v_me uuid := (select auth.uid());
  v_key text;
  v_id uuid;
begin
  if v_me is null then
    raise exception 'not authenticated' using errcode = '28000';
  end if;
  v_key := 'saved:' || v_me::text;
  select id into v_id from public.conversations where direct_key = v_key;
  if v_id is null then
    insert into public.conversations (type, direct_key, created_by)
    values ('saved', v_key, v_me)
    on conflict (direct_key) do nothing
    returning id into v_id;
    if v_id is null then
      select id into v_id from public.conversations where direct_key = v_key;
    else
      insert into public.conversation_members (conversation_id, user_id, role)
      values (v_id, v_me, 'owner');
    end if;
  end if;
  return v_id;
end $$;

revoke execute on function public.get_or_create_direct_conversation(uuid) from public, anon;
revoke execute on function public.get_or_create_saved_conversation() from public, anon;
grant execute on function public.get_or_create_direct_conversation(uuid) to authenticated;
grant execute on function public.get_or_create_saved_conversation() to authenticated;

-- ---------- RLS ----------
alter table public.conversations enable row level security;
alter table public.conversation_members enable row level security;
alter table public.chat_folders enable row level security;
alter table public.chat_folder_items enable row level security;

revoke all on public.conversations from authenticated;
grant select on public.conversations to authenticated;
create policy conversations_select on public.conversations for select to authenticated
  using (public.is_conversation_member(id));

-- Members can see co-members, but may only change their OWN per-chat preferences
-- (column grants stop anyone from promoting themselves to admin).
revoke all on public.conversation_members from authenticated;
grant select on public.conversation_members to authenticated;
grant update (pinned_at, muted_until, archived_at, last_read_at) on public.conversation_members to authenticated;
create policy conversation_members_select on public.conversation_members for select to authenticated
  using (public.is_conversation_member(conversation_id));
create policy conversation_members_update_own on public.conversation_members for update to authenticated
  using (user_id = (select auth.uid()) and left_at is null)
  with check (user_id = (select auth.uid()));

revoke all on public.chat_folders from authenticated;
grant select, insert, delete on public.chat_folders to authenticated;
grant update (name, position) on public.chat_folders to authenticated;
create policy chat_folders_own on public.chat_folders for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

revoke all on public.chat_folder_items from authenticated;
grant select, insert, delete on public.chat_folder_items to authenticated;
create policy chat_folder_items_own on public.chat_folder_items for all to authenticated
  using (exists (select 1 from public.chat_folders f where f.id = folder_id and f.user_id = (select auth.uid())))
  with check (
    exists (select 1 from public.chat_folders f where f.id = folder_id and f.user_id = (select auth.uid()))
    and public.is_conversation_member(conversation_id)
  );
