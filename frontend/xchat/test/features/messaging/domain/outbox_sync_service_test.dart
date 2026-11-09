import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/services/connectivity_service.dart';
import 'package:xchat/features/messaging/domain/repositories/outbox_repository.dart';
import 'package:xchat/features/messaging/domain/services/outbox_sync_service.dart';
import 'package:xchat/features/messaging/domain/usecases/outbox_usecases.dart';

class _MockOutboxRepository extends Mock implements OutboxRepository {}

class _FakeConnectivity implements ConnectivityService {
  final controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> get onlineChanges => controller.stream;

  @override
  Future<bool> get isOnline async => true;
}

void main() {
  late _MockOutboxRepository outbox;
  late _FakeConnectivity connectivity;
  late OutboxSyncService service;

  setUp(() {
    outbox = _MockOutboxRepository();
    connectivity = _FakeConnectivity();
    when(() => outbox.flush()).thenAnswer((_) async => Either<Failure, int>.right(0));
    when(() => outbox.recoverInterrupted()).thenAnswer((_) async => Either<Failure, void>.right(null));
    service = OutboxSyncService(
      connectivity: connectivity,
      flushOutbox: FlushOutbox(outbox),
      recoverInterruptedSends: RecoverInterruptedSends(outbox),
      safetyInterval: const Duration(hours: 1),
    );
  });

  tearDown(() async {
    await service.stop();
    await connectivity.controller.close();
  });

  test('start recovers interrupted sends once, then flushes', () async {
    await service.start();

    verify(() => outbox.recoverInterrupted()).called(1);
    verify(() => outbox.flush()).called(1);
    expect(service.isRunning, isTrue);
  });

  test('flushes when the network comes back, but not when it drops', () async {
    await service.start();
    clearInteractions(outbox);

    connectivity.controller.add(false);
    await Future<void>.delayed(Duration.zero);
    verifyNever(() => outbox.flush());

    connectivity.controller.add(true);
    await Future<void>.delayed(Duration.zero);
    verify(() => outbox.flush()).called(1);
  });

  test('calling start twice does not double-subscribe', () async {
    await service.start();
    await service.start();
    clearInteractions(outbox);

    connectivity.controller.add(true);
    await Future<void>.delayed(Duration.zero);

    verify(() => outbox.flush()).called(1);
  });

  test('stop ends syncing', () async {
    await service.start();
    await service.stop();
    clearInteractions(outbox);

    connectivity.controller.add(true);
    await Future<void>.delayed(Duration.zero);

    verifyNever(() => outbox.flush());
    expect(service.isRunning, isFalse);
  });
}
