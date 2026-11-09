import 'package:equatable/equatable.dart';

/// Returned by repositories / use cases and consumed by BLoCs.
sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No connection']);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.code});
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Not authorized']);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
