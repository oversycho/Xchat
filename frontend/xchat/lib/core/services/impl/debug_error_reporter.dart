import 'package:flutter/foundation.dart';
import 'package:xchat/core/services/error_reporter.dart';

/// Logs to the console. Replace with a Sentry-backed implementation for production.
final class DebugErrorReporter implements ErrorReporter {
  const DebugErrorReporter();

  @override
  void report(Object error, StackTrace stackTrace, {String? context}) {
    debugPrint('[error${context == null ? '' : ' / $context'}] $error\n$stackTrace');
  }
}
