-- User reports and account anonymisation (called by the delete-account Edge Function).

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.profiles (id) on delete cascade,
  target_type text not null check (target_type in ('user', 'message', 'conversation')),
  target_id uuid not null,
  reason text not null check (reason in ('spam', 'abuse', 'violence', 'illegal', 'other')),
  details text check (details is null or char_length(details) <= 1000),
  status text not null default 'open' check (status in ('open', 'reviewing', 'closed')),
  created_at timestamptz not null default now()
);
create index reports_status_idx on public.reports (status, created_at);

alter table public.reports enable row level security;
revoke all on public.reports from authenticated;
grant select on public.reports to authenticated;
grant insert (reporter_id, target_type, target_id, reason, details) on public.reports to authenticated;
-- Reporters see only their own reports; moderation happens with the service role.
create policy reports_select_own on public.reports for select to authenticated
  using (reporter_id = (select auth.uid()));
create policy reports_insert_own on public.reports for insert to authenticated
  with check (reporter_id = (select auth.uid()));

-- Account deletion keeps message rows (other people's history) but removes the person.
create function public.anonymize_user(p_user_id uuid) returns void
language plpgsql security definer set search_path = '' as $$
begin
  update public.profiles
     set username = null, display_name = 'Deleted account', bio = '', avatar_path = null, deleted_at = now()
   where id = p_user_id;
  delete from public.user_devices where user_id = p_user_id;
  delete from public.contacts where owner_id = p_user_id or contact_user_id = p_user_id;
  delete from public.blocked_users where blocker_id = p_user_id or blocked_id = p_user_id;
  delete from public.message_drafts where user_id = p_user_id;
  delete from public.chat_folders where user_id = p_user_id;
  update public.conversation_members set left_at = now() where user_id = p_user_id and left_at is null;
end $$;
revoke execute on function public.anonymize_user(uuid) from public, anon, authenticated;
grant execute on function public.anonymize_user(uuid) to service_role;
