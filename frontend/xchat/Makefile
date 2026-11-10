.PHONY: get upgrade check test run

get:
	flutter pub get

# If `pub get` reports a version conflict (very new SDKs pin test_api/matcher/meta),
# this rewrites every constraint to the newest versions compatible with YOUR toolchain.
upgrade:
	flutter pub upgrade --major-versions

# What CI runs
check: get
	dart format --output=none --set-exit-if-changed lib test
	flutter analyze
	flutter test

test:
	flutter test

# Usage: make run CONFIG=config/dev.json
CONFIG ?= config/dev.json
run:
	flutter run --dart-define-from-file=$(CONFIG)
