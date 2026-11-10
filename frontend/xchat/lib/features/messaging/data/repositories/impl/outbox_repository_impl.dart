import 'package:xchat/core/errors/exceptions.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/utils/guard.dart';
import 'package:xchat/features/messaging/data/datasources/message_local_datasource.dart';
import 'package:xchat/features/messaging/data/datasources/message_remote_datasource.dart';
import 'package:xchat/features/messaging/domain/repositories/outbox_repository.dart';
import 'package:fpdart/fpdart.dart';

final class OutboxRepositoryImpl implements OutboxRepository {
  OutboxRepositoryImpl({
    required MessageRemoteDataSource remote,
    required MessageLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final MessageRemoteDataSource _remote;
  final MessageLocalDataSource _local;
  bool _flushing = false;

  @override
  Future<Either<Failure, int>> flush() async {
    if (_flushing) return Either.right(0);
    _flushing = true;
    try {
      return await guard(_drain);
    } finally {
      _flushing = false;
    }
  }

  Future<int> _drain() async {
    var sent = 0;
    for (final message in await _local.pending()) {
      await _local.updateStatus(message.id, 'sending');
      try {
        final saved = await _remote.send(message);
        await _local.upsertAll([saved]);
        sent++;
      } on NetworkException {
        // Offline: keep the message pending and stop to preserve order.
        await _local.updateStatus(message.id, 'pending');
        rethrow;
      } on AppException catch (e) {
        await _local.updateStatus(message.id, 'failed', failureReason: e.message);
      }
    }
    return sent;
  }

  @override
  Future<Either<Failure, void>> retry(String messageId) => guard<void>(() async {
    final message = await _local.getById(messageId);
    if (message == null || message.status != 'failed') return;
    await _local.updateStatus(messageId, 'pending');
  });

  @override
  Future<Either<Failure, void>> recoverInterrupted() => guard<void>(_local.resetSendingToPending);
}
