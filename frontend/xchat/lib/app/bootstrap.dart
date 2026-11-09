import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:xchat/app/app_bloc_observer.dart';
import 'package:xchat/core/services/error_reporter.dart';
import 'package:xchat/core/services/impl/debug_error_reporter.dart';

typedef AppBuilder = Future<Widget> Function(ErrorReporter reporter);

/// Composition root for process-level concerns: one zone, every uncaught error
/// (Flutter framework, platform, async, BLoC) goes to the same [ErrorReporter].
Future<void> bootstrap(AppBuilder builder) async {
  const reporter = DebugErrorReporter(); // swap for a Sentry-backed reporter in production

  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        reporter.report(details.exception, details.stack ?? StackTrace.current, context: 'FlutterError');
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        reporter.report(error, stack, context: 'PlatformDispatcher');
        return true;
      };
      Bloc.observer = const AppBlocObserver(reporter);

      runApp(await builder(reporter));
    },
    (error, stack) => reporter.report(error, stack, context: 'Zone'),
  );
}
