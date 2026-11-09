-- Foundation: enums, helpers, and API-role hardening.

-- Never let the anonymous role see anything in `public` by default.
-- Authenticated access is granted explicitly (per table / per column) below.
alter default privileges in schema public revoke all on tables from anon;
alter default privileges in schema public revoke all on sequences from anon;
alter default privileges in schema public revoke all on functions from anon;

create type public.conversation_type as enum ('direct', 'saved', 'group', 'channel');
create type public.member_role as enum ('owner', 'admin', 'member', 'subscriber');
create type public.message_type as enum (
  'text', 'image', 'video', 'audio', 'voice', 'video_note', 'document', 'sticker', 'gif', 'system'
);
create type public.attachment_kind as enum (
  'image', 'video', 'audio', 'voice', 'video_note', 'document', 'sticker', 'gif'
);
create type public.message_status as enum ('sent', 'read');

create function public.set_updated_at() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end $$;

-- Returns NULL instead of raising on malformed input (used in storage policies).
create function public.safe_uuid(p text) returns uuid
language plpgsql immutable set search_path = '' as $$
begin
  return p::uuid;
exception when others then
  return null;
end $$;

revoke execute on function public.set_updated_at() from public, anon;
revoke execute on function public.safe_uuid(text) from public, anon;
grant execute on function public.safe_uuid(text) to authenticated;
