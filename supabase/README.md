# Xchat backend (Supabase)

PostgreSQL + Auth (phone OTP) + Realtime + private Storage + one Edge Function.
Everything is versioned here: **never change the schema in the dashboard**, write a migration.

> Status: the SQL migrations and the pgTAP suite were executed against PostgreSQL 16 with a
> stand-in for Supabase's `auth`/`storage` schemas (76 assertions pass, and deliberately breaking
> policies makes them fail). They have **not** been run on the Supabase CLI/Docker stack, and the
> Edge Function has not been run at all. Step 3 below is how you confirm it on your machine.

## 0. What is in here

```
supabase/
  migrations/   0100 foundation (enums, hardening)        0400 messages, attachments, reactions, reads, pins, drafts
                0200 profiles, settings, devices,          0500 private storage buckets + policies
                     contacts, blocks                      0600 reports + account anonymisation
                0300 conversations, members, folders, RPCs
  tests/database/messaging_rls.test.sql   pgTAP security tests (run with `supabase test db`)
  functions/delete-account/index.ts       account deletion (uses the service-role key server-side only)
```

**Not built yet** (later migrations, in this order): groups + permissions + invite links,
channels, stories, calls, notifications/push, bots. Do not point the app at those features yet.

## 1. Install the tools

You need Docker running, plus the Supabase CLI:

```bash
# macOS / Linux (Homebrew)
brew install supabase/tap/supabase
# Windows (Scoop)
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git && scoop install supabase
# No install, any OS with Node 20+
npx supabase --version
```

(`npm install -g supabase` is not supported by the CLI; use one of the above.)

## 2. Create the local project config (once)

From the **repository root** (the folder that contains `supabase/`):

```bash
supabase init        # creates supabase/config.toml; keeps the existing migrations. Say "n" to editor prompts.
```

Then edit `supabase/config.toml` so phone sign-in works locally without paying for SMS:

```toml
[auth]
enable_signup = true

[auth.sms]
enable_signup = true
enable_confirmations = true     # require the OTP

# Local development only: these numbers always accept this code, no SMS is sent.
# Digits only, no "+". The app still passes E.164, e.g. +15555550100.
[auth.sms.test_otp]
15555550100 = "123456"
15555550101 = "123456"
```

(Key names can differ slightly between CLI versions; `supabase init` writes a commented
template, follow its names if they differ.)

## 3. Run it locally and verify

```bash
supabase start        # first run downloads Docker images (a few minutes)
supabase db reset     # drops the local DB and applies every migration from scratch
supabase test db      # runs tests/database/*.test.sql (expect: 76 passing, 0 failing)
supabase db lint      # static checks on the schema/functions
supabase status       # prints API URL, anon key, Studio URL (http://127.0.0.1:54323)
```

If `db reset` or `test db` fails, send me the first error line and I will fix the migration.

Useful while developing:

```bash
supabase migration new add_something   # create a new empty migration (never edit applied ones)
supabase db diff -f my_change          # turn dashboard/local changes into a migration file
supabase stop                          # stop containers (add --no-backup to wipe data)
supabase functions serve delete-account --no-verify-jwt   # run the Edge Function locally
```

## 4. Point the Flutter app at it

`supabase status` prints the **anon key** (`ANON_KEY`). Never use the `service_role` key in the app.

```bash
cd frontend/xchat
# Android emulator (host machine is 10.0.2.2)
flutter run --dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=<anon key>
# iOS simulator / desktop
flutter run --dart-define=SUPABASE_URL=http://127.0.0.1:54321 --dart-define=SUPABASE_ANON_KEY=<anon key>
# Physical phone on the same Wi-Fi: use your computer's LAN IP, e.g. http://192.168.1.20:54321
```

Debug Android builds are already allowed to use plain `http`; release builds are not.

Log in with a test number from step 2 (`+15555550100`, code `123456`).

## 5. Create the hosted project and deploy

1. supabase.com → **New project**. Pick the region closest to your users, save the database password.
2. Link and push:

```bash
supabase login
supabase link --project-ref <project-ref>      # the ref is in the project URL / Settings → General
supabase db push                                # applies migrations/ to the hosted database
supabase functions deploy delete-account        # no secrets needed: URL/keys are injected by Supabase
```

3. Dashboard configuration (cannot be done from migrations):
   - **Authentication → Sign In / Providers → Phone**: enable it and add an SMS provider
     (Twilio Verify, Twilio, MessageBird, or Vonage). Set a short OTP expiry (e.g. 300 s).
   - **Authentication → Rate Limits**: keep SMS limits low.
   - **Authentication → Attack Protection**: enable **CAPTCHA** (hCaptcha or Turnstile). Without it, bots can
     burn your SMS budget (SMS pumping) and this is the most common cost incident for phone-login apps.
   - **Authentication → URL Configuration**: set the site URL / redirect URLs when you add deep links.
   - **Storage**: the `avatars` and `chat-media` buckets are created by migration `0500` (both private). The 50 MB
     per-file cap is the free-plan maximum; raise `file_size_limit` in a new migration on a paid plan.
   - **Realtime**: nothing to enable by hand; migration `0400` adds the tables to the `supabase_realtime` publication.
   - **Database → Backups**: enable daily backups (paid plans) before real users arrive.
4. Copy **Project URL** and the **anon** key (Settings → API) into your release `--dart-define`s or CI secrets.

## 6. Security model (what the tests prove)

- RLS is enabled on every table, and the `anon` role has no access to anything in `public`.
- Clients can only write the columns they are allowed to (column-level grants), so they cannot forge
  `status`, `created_at`, `role`, or `deleted_at`; guard triggers also make `sender_id`, `conversation_id`
  and `type` immutable.
- Conversations are created only through `get_or_create_direct_conversation(uuid)` /
  `get_or_create_saved_conversation()`, so nobody can insert themselves into someone else's chat.
- Messages carry a client-generated UUID: retrying a send is idempotent (no duplicates).
- Deleting a message is a soft delete (tombstone, content removed) so Realtime can notify other clients.
- Read receipts honour the reader's `read_receipts_enabled` setting. `delivered` is intentionally not modelled.
- Storage is private; files are served via signed URLs. Path conventions enforced by policy:
  `avatars/<user id>/<file>` and `chat-media/<conversation id>/<upload id>/<file>`.
- The service-role key exists only inside the Edge Function runtime.

## 7. Known limits / next steps

- Orphaned files in `chat-media` after a message is deleted are not removed yet (needs a scheduled job).
- No per-user rate limiting of message inserts yet (add a trigger or Edge Function gate before launch).
- Phone-number contact discovery (hashed lookup) is not implemented; `contacts` is only an address book.
- `message_pins` has direct-chat rules only; group admin rules arrive with the groups migration.
- Push notifications (FCM tokens are stored in `user_devices`; sending is a later phase).
