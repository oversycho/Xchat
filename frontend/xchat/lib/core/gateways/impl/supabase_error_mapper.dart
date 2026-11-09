import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xchat/core/errors/exceptions.dart';

/// Converts Supabase SDK errors into our own [AppException]s so nothing above
/// the gateways ever sees an SDK type.
Future<T> guardSupabase<T>(Future<T> Function() operation) async {
  try {
    return await operation();
  } on PostgrestException catch (e) {
    // 42501 = insufficient_privilege (raised by RLS violations).
    if (e.code == '42501') throw UnauthorizedException(e.message);
    throw ServerException(e.message, code: e.code);
  } on AuthRetryableFetchException {
    throw const NetworkException();
  } on AuthException catch (e) {
    throw UnauthorizedException(e.message);
  } on FunctionException catch (e) {
    if (e.status == 401 || e.status == 403) throw const UnauthorizedException();
    throw ServerException(e.reasonPhrase ?? 'Function error', code: e.status.toString());
  } on http.ClientException {
    // Also covers SocketException on mobile/desktop (package:http wraps it) and failed fetches on web.
    throw const NetworkException();
  } on TimeoutException {
    throw const NetworkException('Request timed out');
  }
}
