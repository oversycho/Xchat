
-- RLS / security tests for the messaging backend. Run with:  supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(76);

-- helpers ---------------------------------------------------------------
create function pg_temp.act_as(u uuid) returns void language plpgsql as $f$
begin
  perform set_config('request.jwt.claims', json_build_object('sub', u, 'role', 'authenticated')::text, true);
  execute 'set local role authenticated';
end $f$;
create temp table ctx (name text primary key, id uuid);
grant all on ctx to public;

-- fixtures (as postgres) --------------------------------------------------
insert into auth.users (id, phone) values
  ('a0000000-0000-0000-0000-00000000000a', '+15550000001'), ('b0000000-0000-0000-0000-00000000000b', '+15550000002'), ('c0000000-0000-0000-0000-00000000000c', '+15550000003');

select is((select count(*) from public.profiles where id in ('a0000000-0000-0000-0000-00000000000a','b0000000-0000-0000-0000-00000000000b','c0000000-0000-0000-0000-00000000000c')), 3::bigint,
  'a profile row is created automatically for every auth user');
select is((select count(*) from public.user_settings where user_id in ('a0000000-0000-0000-0000-00000000000a','b0000000-0000-0000-0000-00000000000b','c0000000-0000-0000-0000-00000000000c')), 3::bigint,
  'a settings row is created automatically for every auth user');

-- anonymous role ------------------------------------------------------------
set local role anon;
select throws_ok($$select * from public.profiles$$, '42501', null, 'anon cannot read profiles');
select throws_ok($$select * from public.messages$$, '42501', null, 'anon cannot read messages');
reset role;

-- conversations ---------------------------------------------------------------
do $$ begin perform pg_temp.act_as('a0000000-0000-0000-0000-00000000000a'); end $$;
select lives_ok($$insert into ctx select 'direct', public.get_or_create_direct_conversation('b0000000-0000-0000-0000-00000000000b')$$,
  'alice creates a direct conversation with bob');
select lives_ok($$insert into ctx select 'saved', public.get_or_create_saved_conversation()$$,
  'alice gets her saved-messages conversation');
select throws_ok($$select public.get_or_create_direct_conversation('a0000000-0000-0000-0000-00000000000a')$$, '22023', 'invalid user',
  'cannot open a direct conversation with yourself');
select throws_ok($$insert into public.conversations (type) values ('group')$$, '42501', null,
  'clients cannot insert conversations directly');
select is((select count(*) from public.conversations), 2::bigint, 'alice sees her 2 conversations');

reset role;
do $$ begin perform pg_temp.act_as('b0000000-0000-0000-0000-00000000000b'); end $$;
select is((select public.get_or_create_direct_conversation('a0000000-0000-0000-0000-00000000000a')), (select id from ctx where name='direct'),
  'bob resolving the same pair gets the same conversation (idempotent)');
select is((select count(*) from public.conversation_members), 2::bigint, 'bob sees both members of the direct chat');
select is((select count(*) from public.conversations), 1::bigint, 'bob cannot see alices saved conversation');

-- messages: sending -------------------------------------------------------------
reset role;
do $$ begin perform pg_temp.act_as('a0000000-0000-0000-0000-00000000000a'); end $$;
select lives_ok($$insert into public.messages (id, conversation_id, sender_id, text)
  values ('11111111-1111-4111-8111-111111111111', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', 'hello')$$, 'alice sends a message');
select lives_ok($$insert into public.messages (id, conversation_id, sender_id, text)
  values ('11111111-1111-4111-8111-111111111111', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', 'hello')
  on conflict (id) do update set id = excluded.id, conversation_id = excluded.conversation_id,
    sender_id = excluded.sender_id, type = excluded.type, text = excluded.text, reply_to_id = excluded.reply_to_id$$,
  'retrying the same send (client upsert) is idempotent');
select is((select count(*) from public.messages where id = '11111111-1111-4111-8111-111111111111'), 1::bigint, 'no duplicate after retry');
select throws_ok($$insert into public.messages (id, conversation_id, sender_id, text)
  values ('44444444-4444-4444-8444-444444444444', (select id from ctx where name='direct'), 'b0000000-0000-0000-0000-00000000000b', 'spoof')$$, '42501', null,
  'cannot send as someone else');
select throws_ok($$insert into public.messages (id, conversation_id, sender_id, text, status)
  values ('44444444-4444-4444-8444-444444444444', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', 'x', 'read')$$, '42501', null,
  'cannot forge status');
select throws_ok($$insert into public.messages (id, conversation_id, sender_id, text, created_at)
  values ('44444444-4444-4444-8444-444444444444', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', 'x', now() - interval '1 year')$$, '42501', null,
  'cannot forge created_at');
select throws_ok($$insert into public.messages (id, conversation_id, sender_id, type, text)
  values ('44444444-4444-4444-8444-444444444444', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', 'system', 'x')$$, '42501', null,
  'cannot send system messages');
select throws_ok($$insert into public.messages (id, conversation_id, sender_id, text)
  values ('44444444-4444-4444-8444-444444444444', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', '   ')$$, '23514', null,
  'blank text messages are rejected');
select throws_ok($$delete from public.messages where id = '11111111-1111-4111-8111-111111111111'$$, '42501', null,
  'clients cannot hard-delete messages');
select ok((select last_message_id = '11111111-1111-4111-8111-111111111111' from public.conversations where id = (select id from ctx where name='direct')),
  'conversation last_message is maintained');

-- messages: visibility ----------------------------------------------------------
reset role;
do $$ begin perform pg_temp.act_as('b0000000-0000-0000-0000-00000000000b'); end $$;
select is((select text from public.messages where id = '11111111-1111-4111-8111-111111111111'), 'hello', 'bob (member) can read the message');
update public.messages set text = 'hacked' where id = '11111111-1111-4111-8111-111111111111';
select throws_ok($$update public.messages set status = 'read' where id = '11111111-1111-4111-8111-111111111111'$$, '42501', null,
  'clients cannot update status');

reset role;
do $$ begin perform pg_temp.act_as('c0000000-0000-0000-0000-00000000000c'); end $$;
select is((select count(*) from public.messages), 0::bigint, 'carol (outsider) sees no messages');
select throws_ok($$insert into public.messages (id, conversation_id, sender_id, text)
  values ('44444444-4444-4444-8444-444444444444', (select id from ctx where name='direct'), 'c0000000-0000-0000-0000-00000000000c', 'intrusion')$$, '42501', null,
  'outsider cannot post into someone elses conversation');
select is((select count(*) from public.conversation_members), 0::bigint, 'outsider sees no members');

-- messages: edit / delete --------------------------------------------------------
reset role;
do $$ begin perform pg_temp.act_as('a0000000-0000-0000-0000-00000000000a'); end $$;
select is((select text from public.messages where id = '11111111-1111-4111-8111-111111111111'), 'hello', 'another members update did not change the text');
update public.messages set text = 'hello edited' where id = '11111111-1111-4111-8111-111111111111';
select ok((select text = 'hello edited' and edited_at is not null from public.messages where id = '11111111-1111-4111-8111-111111111111'),
  'owner edit works and edited_at is set by the server');
select throws_ok($$update public.messages set conversation_id = (select id from ctx where name='saved') where id = '11111111-1111-4111-8111-111111111111'$$,
  '42501', null, 'a message cannot be moved to another conversation');

insert into public.messages (id, conversation_id, sender_id, text) values
  ('22222222-2222-4222-8222-222222222222', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', 'read me'),
  ('33333333-3333-4333-8333-333333333333', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', 'read me too');
update public.messages set deleted_at = now() where id = '11111111-1111-4111-8111-111111111111';
select ok((select deleted_at is not null and text is null from public.messages where id = '11111111-1111-4111-8111-111111111111'),
  'soft delete tombstones the row and drops its content');

-- read receipts -----------------------------------------------------------------
reset role;
do $$ begin perform pg_temp.act_as('b0000000-0000-0000-0000-00000000000b'); end $$;
select lives_ok($$insert into public.message_reads (message_id, user_id) values ('22222222-2222-4222-8222-222222222222', 'b0000000-0000-0000-0000-00000000000b')$$,
  'bob marks a message read');
select lives_ok($$insert into public.message_reads (message_id, user_id) values ('22222222-2222-4222-8222-222222222222', 'b0000000-0000-0000-0000-00000000000b')
  on conflict (message_id, user_id) do update set message_id = excluded.message_id, user_id = excluded.user_id, read_at = excluded.read_at$$,
  'marking read twice (client upsert) is idempotent');
select throws_ok($$insert into public.message_reads (message_id, user_id) values ('22222222-2222-4222-8222-222222222222', 'a0000000-0000-0000-0000-00000000000a')$$, '42501', null,
  'cannot record a read for someone else');
update public.user_settings set read_receipts_enabled = false where user_id = 'b0000000-0000-0000-0000-00000000000b';
select lives_ok($$insert into public.message_reads (message_id, user_id) values ('33333333-3333-4333-8333-333333333333', 'b0000000-0000-0000-0000-00000000000b')$$,
  'bob reads a second message with receipts disabled');

reset role;
do $$ begin perform pg_temp.act_as('a0000000-0000-0000-0000-00000000000a'); end $$;
select is((select status::text from public.messages where id = '22222222-2222-4222-8222-222222222222'), 'read', 'sender sees the message as read');
select is((select status::text from public.messages where id = '33333333-3333-4333-8333-333333333333'), 'sent',
  'read receipts disabled by the reader are respected');

reset role;
do $$ begin perform pg_temp.act_as('c0000000-0000-0000-0000-00000000000c'); end $$;
select throws_ok($$insert into public.message_reads (message_id, user_id) values ('33333333-3333-4333-8333-333333333333', 'c0000000-0000-0000-0000-00000000000c')$$, '42501', null,
  'outsider cannot mark messages read');

-- reactions -----------------------------------------------------------------------
reset role;
do $$ begin perform pg_temp.act_as('b0000000-0000-0000-0000-00000000000b'); end $$;
select lives_ok($$insert into public.message_reactions (message_id, user_id, emoji) values ('22222222-2222-4222-8222-222222222222', 'b0000000-0000-0000-0000-00000000000b', '👍')$$,
  'bob reacts');
select lives_ok($$insert into public.message_reactions (message_id, user_id, emoji) values ('22222222-2222-4222-8222-222222222222', 'b0000000-0000-0000-0000-00000000000b', '👍')
  on conflict (message_id, user_id, emoji) do update set message_id = excluded.message_id, user_id = excluded.user_id, emoji = excluded.emoji$$,
  'reacting twice (client upsert) is idempotent');
select throws_ok($$insert into public.message_reactions (message_id, user_id, emoji) values ('22222222-2222-4222-8222-222222222222', 'a0000000-0000-0000-0000-00000000000a', '❤️')$$,
  '42501', null, 'cannot react as someone else');

reset role;
do $$ begin perform pg_temp.act_as('c0000000-0000-0000-0000-00000000000c'); end $$;
select throws_ok($$insert into public.message_reactions (message_id, user_id, emoji) values ('22222222-2222-4222-8222-222222222222', 'c0000000-0000-0000-0000-00000000000c', '👍')$$,
  '42501', null, 'outsider cannot react');

reset role;
do $$ begin perform pg_temp.act_as('a0000000-0000-0000-0000-00000000000a'); end $$;
select is((select count(*) from public.message_reactions where message_id = '22222222-2222-4222-8222-222222222222'), 1::bigint, 'alice sees bobs reaction');

-- attachments ----------------------------------------------------------------------
select lives_ok($$insert into public.message_attachments (id, message_id, kind, storage_path, mime_type, size_bytes)
  values ('55555555-5555-4555-8555-555555555555', '22222222-2222-4222-8222-222222222222', 'image', (select id from ctx where name='direct')::text || '/77777777-7777-4777-8777-777777777777/a.png', 'image/png', 1024)$$,
  'sender attaches a file stored under the conversation prefix');
select throws_ok($$insert into public.message_attachments (id, message_id, kind, storage_path, mime_type, size_bytes)
  values ('66666666-6666-4666-8666-666666666666', '22222222-2222-4222-8222-222222222222', 'image', 'someone-elses-conversation/x.png', 'image/png', 1024)$$, '23514', null,
  'attachment paths outside the conversation prefix are rejected');

reset role;
do $$ begin perform pg_temp.act_as('b0000000-0000-0000-0000-00000000000b'); end $$;
select throws_ok($$insert into public.message_attachments (id, message_id, kind, storage_path, mime_type, size_bytes)
  values ('66666666-6666-4666-8666-666666666666', '22222222-2222-4222-8222-222222222222', 'image', (select id from ctx where name='direct')::text || '/77777777-7777-4777-8777-777777777777/b.png', 'image/png', 1)$$,
  '42501', null, 'only the sender can attach files to a message');
select is((select count(*) from public.message_attachments), 1::bigint, 'bob (member) can see the attachment');

reset role;
do $$ begin perform pg_temp.act_as('c0000000-0000-0000-0000-00000000000c'); end $$;
select is((select count(*) from public.message_attachments), 0::bigint, 'outsider cannot see attachments');

-- storage ---------------------------------------------------------------------------
reset role;
insert into storage.objects (bucket_id, name, owner_id)
  values ('chat-media', (select id from ctx where name='direct')::text || '/77777777-7777-4777-8777-777777777777/a.png', 'a0000000-0000-0000-0000-00000000000a');
select is((select count(*) from storage.buckets where public), 0::bigint, 'all buckets are private');

do $$ begin perform pg_temp.act_as('b0000000-0000-0000-0000-00000000000b'); end $$;
select is((select count(*) from storage.objects where bucket_id = 'chat-media'), 1::bigint,
  'conversation member can read chat media');
reset role;
do $$ begin perform pg_temp.act_as('c0000000-0000-0000-0000-00000000000c'); end $$;
select is((select count(*) from storage.objects where bucket_id = 'chat-media'), 0::bigint,
  'outsider cannot read chat media');
select throws_ok($$insert into storage.objects (bucket_id, name, owner_id)
  values ('chat-media', (select id from public.conversations limit 1)::text || '/x/y.png', 'c0000000-0000-0000-0000-00000000000c')$$, '42501', null,
  'outsider cannot upload into a conversation folder');

reset role;
do $$ begin perform pg_temp.act_as('a0000000-0000-0000-0000-00000000000a'); end $$;
select lives_ok($$insert into storage.objects (bucket_id, name, owner_id)
  values ('chat-media', (select id from ctx where name='direct')::text || '/88888888-8888-4888-8888-888888888888/b.png', 'a0000000-0000-0000-0000-00000000000a')$$,
  'member can upload into the conversation folder');
select throws_ok($$insert into storage.objects (bucket_id, name, owner_id) values ('chat-media', 'not-a-uuid/x.png', 'a0000000-0000-0000-0000-00000000000a')$$,
  '42501', null, 'malformed folder names are rejected');
select lives_ok($$insert into storage.objects (bucket_id, name, owner_id) values ('avatars', 'a0000000-0000-0000-0000-00000000000a/me.png', 'a0000000-0000-0000-0000-00000000000a')$$,
  'user uploads their own avatar');
select throws_ok($$insert into storage.objects (bucket_id, name, owner_id) values ('avatars', 'b0000000-0000-0000-0000-00000000000b/me.png', 'a0000000-0000-0000-0000-00000000000a')$$,
  '42501', null, 'user cannot write into another users avatar folder');

-- blocking ----------------------------------------------------------------------------
reset role;
do $$ begin perform pg_temp.act_as('b0000000-0000-0000-0000-00000000000b'); end $$;
select lives_ok($$insert into public.blocked_users (blocker_id, blocked_id) values ('b0000000-0000-0000-0000-00000000000b', 'a0000000-0000-0000-0000-00000000000a')$$, 'bob blocks alice');
reset role;
do $$ begin perform pg_temp.act_as('a0000000-0000-0000-0000-00000000000a'); end $$;
select throws_ok($$insert into public.messages (id, conversation_id, sender_id, text)
  values ('44444444-4444-4444-8444-444444444444', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', 'am i blocked?')$$, '42501', null,
  'a blocked user cannot send in the direct chat');
select throws_ok($$select public.get_or_create_direct_conversation('b0000000-0000-0000-0000-00000000000b')$$, '42501', 'blocked',
  'a blocked user cannot (re)open the conversation');
select is((select count(*) from public.blocked_users), 0::bigint, 'block lists are private');
reset role;
do $$ begin perform pg_temp.act_as('b0000000-0000-0000-0000-00000000000b'); end $$;
delete from public.blocked_users where blocker_id = 'b0000000-0000-0000-0000-00000000000b';
reset role;
do $$ begin perform pg_temp.act_as('a0000000-0000-0000-0000-00000000000a'); end $$;
select lives_ok($$insert into public.messages (id, conversation_id, sender_id, text)
  values ('44444444-4444-4444-8444-444444444444', (select id from ctx where name='direct'), 'a0000000-0000-0000-0000-00000000000a', 'unblocked')$$, 'sending works again after unblock');

-- membership / per-chat preferences -----------------------------------------------------
select throws_ok($$update public.conversation_members set role = 'admin' where user_id = 'a0000000-0000-0000-0000-00000000000a'$$, '42501', null,
  'members cannot change their own role');
select lives_ok($$update public.conversation_members set pinned_at = now()
  where user_id = 'a0000000-0000-0000-0000-00000000000a' and conversation_id = (select id from ctx where name='direct')$$, 'alice pins the chat');
update public.conversation_members set pinned_at = now()
  where user_id = 'b0000000-0000-0000-0000-00000000000b' and conversation_id = (select id from ctx where name='direct');
reset role;
do $$ begin perform pg_temp.act_as('b0000000-0000-0000-0000-00000000000b'); end $$;
select is((select pinned_at from public.conversation_members
  where user_id = 'b0000000-0000-0000-0000-00000000000b' and conversation_id = (select id from ctx where name='direct')), null::timestamptz,
  'a member cannot change another members preferences');

-- profiles ---------------------------------------------------------------------------------
select lives_ok($$update public.profiles set username = 'bob_the_b', display_name = 'Bob' where id = 'b0000000-0000-0000-0000-00000000000b'$$, 'bob sets his profile');
select throws_ok($$update public.profiles set username = 'No Spaces!' where id = 'b0000000-0000-0000-0000-00000000000b'$$, '23514', null, 'invalid username format rejected');
select throws_ok($$update public.profiles set deleted_at = now() where id = 'b0000000-0000-0000-0000-00000000000b'$$, '42501', null, 'cannot set deleted_at');
select throws_ok($$update public.profiles set avatar_path = 'other/x.png' where id = 'b0000000-0000-0000-0000-00000000000b'$$, '23514', null,
  'avatar path must live in the users own folder');
update public.profiles set display_name = 'pwned' where id = 'a0000000-0000-0000-0000-00000000000a';
reset role;
do $$ begin perform pg_temp.act_as('a0000000-0000-0000-0000-00000000000a'); end $$;
select is((select display_name from public.profiles where id = 'a0000000-0000-0000-0000-00000000000a'), '', 'cannot edit another users profile');
select throws_ok($$update public.profiles set username = 'bob_the_b' where id = 'a0000000-0000-0000-0000-00000000000a'$$, '23505', null, 'usernames are unique');

-- reports / account deletion -----------------------------------------------------------------
select lives_ok($$insert into public.reports (reporter_id, target_type, target_id, reason)
  values ('a0000000-0000-0000-0000-00000000000a', 'user', 'b0000000-0000-0000-0000-00000000000b', 'spam')$$, 'alice files a report');
select throws_ok($$insert into public.reports (reporter_id, target_type, target_id, reason)
  values ('b0000000-0000-0000-0000-00000000000b', 'user', 'c0000000-0000-0000-0000-00000000000c', 'spam')$$, '42501', null, 'cannot file a report as someone else');
select throws_ok($$select public.anonymize_user('b0000000-0000-0000-0000-00000000000b')$$, '42501', null, 'clients cannot call anonymize_user');
reset role;
select lives_ok($$select public.anonymize_user('c0000000-0000-0000-0000-00000000000c')$$, 'service code can anonymize a user');
select ok((select deleted_at is not null and display_name = 'Deleted account' from public.profiles where id = 'c0000000-0000-0000-0000-00000000000c'),
  'anonymised profile is tombstoned');

-- realtime -----------------------------------------------------------------------------------
select ok(exists (select 1 from pg_publication_tables
  where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'messages'),
  'messages are published to realtime');

select * from finish();
rollback;
