# xchat (Flutter app)

Telegram-inspired messenger. Flutter + Supabase, Clean Architecture, BLoC/Cubit only.
Platforms: Android, iOS, Web. Backend and setup commands: see `../../supabase/README.md`.

```bash
cp config/dev.example.json config/dev.json   # paste your Supabase URL + anon key
make get                                      # flutter pub get
flutter analyze && flutter test
make run CONFIG=config/dev.json
```

If `flutter pub get` reports a version conflict, run `make upgrade` (rewrites constraints to the
newest versions compatible with your SDK).

There is no code generation: states and events are plain sealed classes (Equatable), so no `build_runner` step.

Layout and rules: `lib/core` (shared interfaces/services), `lib/features/<feature>/{domain,data,presentation}`,
`lib/app` (router, theme, bootstrap). `test/architecture` enforces the layer boundaries.
Project status and open work: `../../DEVELOPMENT_STATUS.md`.
