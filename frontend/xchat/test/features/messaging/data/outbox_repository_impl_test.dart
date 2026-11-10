import 'package:xchat/core/errors/exceptions.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/messaging/data/datasources/message_local_datasource.dart';
import 'package:xchat/features/messaging/data/datasources/message_remote_datasource.dart';
import 'package:xchat/features/messaging/data/models/message_model.dart';
import 'package:xchat/features/messaging/data/repositories/impl/outbox_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements MessageRemoteDataSource {}

class _MockLocal extends Mock implements MessageLocalDataSource {}

MessageModel _model(String id, {String status = 'pending'}) => MessageModel(
  id: id,
  conversationId: 'c1',
  senderId: 'u1',
  type: 'text',
  text: 'hi',
  status: status,
  createdAt: DateTime.utc(2026, 1, 1),
);

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late OutboxRepositoryImpl outbox;

  setUpAll(() {
    registerFallbackValue(_model('fallback'));
    registerFallbackValue(<MessageModel>[]);
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    outbox = OutboxRepositoryImpl(remote: remote, local: local);
    when(
      () => local.updateStatus(any(), any(), failureReason: any(named: 'failureReason')),
    ).thenAnswer((_) async {});
    when(() => local.upsertAll(any())).thenAnswer((_) async {});
  });

  test('sends pending messages and stores the server copy', () async {
    when(() => local.pending()).thenAnswer((_) async => [_model('m1')]);
    when(() => remote.send(any())).thenAnswer((_) async => _model('m1', status: 'sent'));

    final result = await outbox.flush();

    expect(result.getOrElse((_) => -1), 1);
    verify(() => local.upsertAll(any())).called(1);
  });

  test('network error keeps the message pending and returns NetworkFailure', () async {
    when(() => local.pending()).thenAnswer((_) async => [_model('m1')]);
    when(() => remote.send(any())).thenThrow(const NetworkException());

    final result = await outbox.flush();

    expect(result.isLeft(), isTrue);
    result.match((f) => expect(f, isA<NetworkFailure>()), (_) => fail('expected failure'));
    verify(
      () => local.updateStatus('m1', 'pending', failureReason: any(named: 'failureReason')),
    ).called(1);
  });

  test('server error marks the message failed with the reason', () async {
    when(() => local.pending()).thenAnswer((_) async => [_model('m1')]);
    when(() => remote.send(any())).thenThrow(const ServerException('boom'));

    final result = await outbox.flush();

    expect(result.getOrElse((_) => -1), 0);
    verify(() => local.updateStatus('m1', 'failed', failureReason: 'boom')).called(1);
  });
}
