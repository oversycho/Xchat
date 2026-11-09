-- Private storage buckets + policies. Everything is served through signed URLs.
--   avatars:     "<user id>/<file>"
--   chat-media:  "<conversation id>/<upload id>/<file>"
-- NOTE: Supabase's free plan caps a single upload at 50 MB; raise file_size_limit on paid plans.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types) values
  ('avatars', 'avatars', false, 5242880,
    array['image/jpeg', 'image/png', 'image/webp']),
  ('chat-media', 'chat-media', false, 52428800,
    array[
      'image/jpeg', 'image/png', 'image/webp', 'image/gif',
      'video/mp4', 'video/quicktime', 'video/webm',
      'audio/mpeg', 'audio/mp4', 'audio/aac', 'audio/ogg', 'audio/webm', 'audio/wav',
      'application/pdf', 'application/zip', 'text/plain',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    ])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- avatars: any signed-in user may read (needed to render other people's avatars); owners write.
create policy avatars_read on storage.objects for select to authenticated
  using (bucket_id = 'avatars');
create policy avatars_insert_own on storage.objects for insert to authenticated
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy avatars_update_own on storage.objects for update to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy avatars_delete_own on storage.objects for delete to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);

-- chat-media: conversation members read; people allowed to post upload; uploader deletes. No updates.
create policy chat_media_read on storage.objects for select to authenticated
  using (
    bucket_id = 'chat-media'
    and public.is_conversation_member(public.safe_uuid((storage.foldername(name))[1]))
  );
create policy chat_media_insert on storage.objects for insert to authenticated
  with check (
    bucket_id = 'chat-media'
    and public.can_post_in_conversation(public.safe_uuid((storage.foldername(name))[1]))
  );
create policy chat_media_delete_own on storage.objects for delete to authenticated
  using (bucket_id = 'chat-media' and owner_id = (select auth.uid())::text);
