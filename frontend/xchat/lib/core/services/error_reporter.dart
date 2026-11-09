/// Single entry point for unexpected errors. Swap the implementation
/// (e.g. Sentry) in DI; nothing else in the app changes.
abstract interface class ErrorReporter {
  void report(Object error, StackTrace stackTrace, {String? context});
}
