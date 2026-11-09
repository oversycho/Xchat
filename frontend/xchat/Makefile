.PHONY: get upgrade gen watch check test run

get:
	flutter pub get

# If `pub get` reports a version conflict (very new SDKs pin test_api/matcher/meta),
# this rewrites every constraint to the newest versions compatible with YOUR toolchain.
upgrade:
	flutter pub upgrade --major-versions

# Generate *.freezed.dart (required after every pull that touches freezed classes)
gen:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

# What CI runs
check: get gen
	dart format --output=none --set-exit-if-changed lib test
	flutter analyze
	flutter test

test:
	flutter test

# Usage: make run CONFIG=config/dev.json
CONFIG ?= config/dev.json
run:
	flutter run --dart-define-from-file=$(CONFIG)
