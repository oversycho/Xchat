# DEVELOPMENT_STATUS

## Verification status (read first)
| Part | How far it was checked |
|---|---|
| `supabase/migrations/*` + `supabase/tests/database/*` | **Executed** on PostgreSQL 16 with a stand-in for Supabase's `auth`/`storage` schemas: 6 migrations apply from scratch, 76 pgTAP assertions pass, and deliberately breaking policies/triggers makes them fail. **Not** yet run through the Supabase CLI/Docker stack. |
| `supabase/functions/delete-account` | Not executed. |
| Dart: core, domain, data, BLoCs/Cubits (~65 files) | **Analysed with the real Dart analyzer (3.13.7): 0 errors, 0 warnings** (strict-casts/strict-raw-types on), against the real `fpdart`/`equatable`/`bloc`/`bloc_concurrency`/`get_it` sources. **Behaviour executed** on an in-memory DB with fake servers: 53 checks for messaging (pagination over 70 messages, offline send, retry, realtime insert/edit/delete, resync, outbox recovery, double-tap guard, composer reply/edit/draft) and 14 for AuthBloc, all passing. These scripts are not shipped. |
| Dart: Flutter UI, router, app shell, Supabase/shared_preferences/connectivity gateways, DI, `main.dart`, all `flutter_test` tests | **Only parsed and formatted** (all 111 files, `dart format` clean). NOT type-checked and NOT run: needs the Flutter SDK + pub.dev, which were unavailable. |
| Dependency resolution (`pub get`) | Not possible offline. See the note below. |

Matched against the supplied scaffold: package `xchat`, Dart `>=3.12.1`, `flutter_lints 6`, platforms android/ios/web
(iOS 13.0, Android `flutter.minSdkVersion`, AGP 9). Code is web-safe (no `dart:io`). Dependency versions could NOT be
resolved offline; the scaffold's lockfile pins `test_api 0.7.11`, `matcher 0.12.19`, `meta 1.18.0`, which `bloc_test`
and `mocktail` must be compatible with. If `pub get` conflicts, run `make upgrade`.

First run on your machine:
```
cd frontend/xchat
flutter pub get
flutter analyze && flutter test
```
Backend: see `supabase/README.md` (commands start at section 1).

## Layout
```
supabase/                     backend (migrations, pgTAP tests, Edge Function) + README with commands
frontend/xchat/lib/
  main.dart                   composition root: config -> Supabase.initialize -> DI -> runApp
  app/                        app_config, bootstrap (error zone), router (GoRouter + auth redirect), theme, shell pages
  core/                       errors, guard, UseCase, mappers, gateways (interfaces + impl/), services (interfaces + impl/), di
  features/
    authentication/           phone OTP: domain / data / presentation (AuthBloc)
    messaging/                domain / data / presentation (MessageListBloc, MessageComposerBloc), OutboxSyncService
    settings/                 theme (ThemeCubit)
    connectivity/             ConnectivityCubit
.github/workflows/            backend.yml (supabase test db), frontend.yml (analyze + test)
```

## State management (BLoC only)
- **Global** (created once in `XchatApp`): `AuthBloc`, `ThemeCubit`, `ConnectivityCubit`.
- **Conversation-scoped** (create at the chat route, disposed with it): `MessageListBloc`, `MessageComposerBloc`:
  `sl<MessageListBloc>(param1: conversationId, param2: currentUserId)`.
- Router redirect is a pure function of `AuthState` (`authRedirect`), unit-tested.
- `OutboxSyncService` (not a BLoC) flushes the send queue on sign-in, on reconnect and every minute; stopped on sign-out.
- Sign-out wipes local data (`LocalDataCleaner`) only after the server session is really gone.

## Best practices in place
Interface-first layering enforced by `test/architecture` (domain/presentation/data/core/feature boundaries,
`*Impl` only visible to composition roots, SDKs only inside `impl/`), `guard()` turning exceptions into `Failure`s,
single error pipeline (`bootstrap` -> `ErrorReporter`), `--dart-define-from-file` config with an https check for prod,
strict analyzer (`strict-casts`, `strict-raw-types`, `unawaited_futures`, `always_use_package_imports`),
no code generation (sealed Equatable states/events), CI for both halves, column-level grants + RLS + pgTAP on the backend.

## NOT done / known gaps
- **Isar `LocalDatabase`.** DI uses the in-memory one: no persistence across restarts (blocks real offline-first).
- **UI:** only splash/login/verify/placeholder home exist. No chat list, chat screen, profile creation, contacts.
- **Profile** use cases (CreateProfile/UpdateProfile) and avatar upload.
- Messaging: forward, pin, schedule, in-chat search, location/contact messages; typing/presence/read-receipt/selection
  cubits; media upload (`MediaBloc`).
- Realtime on the client only listens to `messages`; the backend already publishes attachments/reactions/conversations/
  members, so the data source can be extended without a migration.
- Edit/delete are online-only. Failed sends do not block later ones (order can differ).
- Backend: groups, channels, stories, calls, notifications/push, bots; storage clean-up job; message rate limiting.
- Localization (l10n), Sentry reporter, app icons/flavors.
- No `delivered` status by design.
