import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:xchat/core/services/error_reporter.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver(this._reporter);
  final ErrorReporter _reporter;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _reporter.report(error, stackTrace, context: bloc.runtimeType.toString());
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    if (kDebugMode) debugPrint('[Bloc] ${bloc.runtimeType}: ${transition.event.runtimeType}');
    super.onTransition(bloc, transition);
  }
}
