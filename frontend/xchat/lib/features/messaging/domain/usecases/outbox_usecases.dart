import 'dart:async';

import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/usecases/usecase.dart';
import 'package:xchat/features/messaging/domain/repositories/outbox_repository.dart';
import 'package:fpdart/fpdart.dart';

final class FlushOutbox implements UseCase<int, NoParams> {
  const FlushOutbox(this._repository);
  final OutboxRepository _repository;

  @override
  Future<Either<Failure, int>> call(NoParams params) => _repository.flush();
}

final class RetryMessage implements UseCase<void, String> {
  const RetryMessage(this._repository);
  final OutboxRepository _repository;

  @override
  Future<Either<Failure, void>> call(String messageId) async {
    final result = await _repository.retry(messageId);
    return result.map((_) {
      unawaited(_repository.flush());
    });
  }
}

final class RecoverInterruptedSends implements UseCase<void, NoParams> {
  const RecoverInterruptedSends(this._repository);
  final OutboxRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) => _repository.recoverInterrupted();
}
