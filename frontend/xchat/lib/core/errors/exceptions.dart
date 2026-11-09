/// Thrown by the data layer (data sources / gateways). Never leaves the data layer:
/// repositories convert these into [Failure]s via `guard`.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'No connection']);
}

final class ServerException extends AppException {
  const ServerException(super.message, {this.code});
  final String? code;
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Not authorized']);
}

final class CacheException extends AppException {
  const CacheException(super.message);
}

final class RealtimeException extends AppException {
  const RealtimeException(super.message);
}
