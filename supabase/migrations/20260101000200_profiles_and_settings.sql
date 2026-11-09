-- Profiles, settings, devices, contacts, blocks.

create table public.profiles (
  id uuid primary key references auth.users (id),
  username text unique,
  display_name text not null default '',
  bio text not null default '',
  avatar_path text,
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_username_format check (username is null or username ~ '^[a-z][a-z0-9_]{4,31}$'),
  constraint profiles_display_name_len check (char_length(display_name) <= 64),
  constraint profiles_bio_len check (char_length(bio) <= 140),
  -- avatars live in the `avatars` bucket under "<user id>/..."
  constraint profiles_avatar_owner check (avatar_path is null or avatar_path like id::text || '/%')
);
create trigger profiles_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();

create table public.user_settings (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  last_seen_visibility text not null default 'everyone'
    check (last_seen_visibility in ('everyone', 'contacts', 'nobody')),
  read_receipts_enabled boolean not null default true,
  theme_mode text not null default 'system' check (theme_mode in ('system', 'light', 'dark')),
  language text not null default 'en' check (char_length(language) between 2 and 10),
  notifications jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
create trigger user_settings_updated_at before update on public.user_settings
  for each row execute function public.set_updated_at();

create table public.user_devices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  platform text not null check (platform in ('android', 'ios', 'web', 'desktop')),
  fcm_token text unique,
  device_name text,
  last_active_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
create index user_devices_user_idx on public.user_devices (user_id);

create table public.contacts (
  owner_id uuid not null references public.profiles (id) on delete cascade,
  contact_user_id uuid not null references public.profiles (id) on delete cascade,
  alias text check (alias is null or char_length(alias) <= 64),
  created_at timestamptz not null default now(),
  primary key (owner_id, contact_user_id),
  check (owner_id <> contact_user_id)
);

create table public.blocked_users (
  blocker_id uuid not null references public.profiles (id) on delete cascade,
  blocked_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);
create index blocked_users_blocked_idx on public.blocked_users (blocked_id);

-- A profile + settings row is created automatically for every new auth user.
create function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id) values (new.id);
  insert into public.user_settings (user_id) values (new.id);
  return new;
end $$;
revoke execute on function public.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- True when either user has blocked the other.
create function public.is_blocked_between(a uuid, b uuid) returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.blocked_users
    where (blocker_id = a and blocked_id = b) or (blocker_id = b and blocked_id = a)
  )
$$;
revoke execute on function public.is_blocked_between(uuid, uuid) from public, anon;
grant execute on function public.is_blocked_between(uuid, uuid) to authenticated;

-- ---------- RLS ----------
alter table public.profiles enable row level security;
alter table public.user_settings enable row level security;
alter table public.user_devices enable row level security;
alter table public.contacts enable row level security;
alter table public.blocked_users enable row level security;

-- Profiles: readable by any signed-in user (like Telegram); only the owner edits, and only safe columns.
revoke all on public.profiles from authenticated;
grant select on public.profiles to authenticated;
grant update (username, display_name, bio, avatar_path) on public.profiles to authenticated;
create policy profiles_select on public.profiles for select to authenticated
  using (deleted_at is null or id = (select auth.uid()));
create policy profiles_update_own on public.profiles for update to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

revoke all on public.user_settings from authenticated;
grant select on public.user_settings to authenticated;
grant update (last_seen_visibility, read_receipts_enabled, theme_mode, language, notifications)
  on public.user_settings to authenticated;
create policy user_settings_select_own on public.user_settings for select to authenticated
  using (user_id = (select auth.uid()));
create policy user_settings_update_own on public.user_settings for update to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

revoke all on public.user_devices from authenticated;
grant select, insert, delete on public.user_devices to authenticated;
grant update (fcm_token, device_name, last_active_at) on public.user_devices to authenticated;
create policy user_devices_own on public.user_devices for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

revoke all on public.contacts from authenticated;
grant select, insert, delete on public.contacts to authenticated;
grant update (alias) on public.contacts to authenticated;
create policy contacts_own on public.contacts for all to authenticated
  using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));

revoke all on public.blocked_users from authenticated;
grant select, insert, delete on public.blocked_users to authenticated;
create policy blocked_users_own on public.blocked_users for all to authenticated
  using (blocker_id = (select auth.uid())) with check (blocker_id = (select auth.uid()));
