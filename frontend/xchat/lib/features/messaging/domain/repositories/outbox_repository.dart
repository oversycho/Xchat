import 'package:xchat/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class OutboxRepository {
  /// Sends pending messages oldest-first. Returns how many were sent.
  Future<Either<Failure, int>> flush();

  /// Moves a `failed` message back to `pending`.
  Future<Either<Failure, void>> retry(String messageId);

  /// Messages left in `sending` by an app kill go back to `pending`.
  Future<Either<Failure, void>> recoverInterrupted();
}
