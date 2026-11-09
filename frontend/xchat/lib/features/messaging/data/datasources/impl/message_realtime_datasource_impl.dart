import 'package:xchat/core/gateways/realtime_gateway.dart';
import 'package:xchat/features/messaging/data/datasources/message_realtime_datasource.dart';

final class MessageRealtimeDataSourceImpl implements MessageRealtimeDataSource {
  MessageRealtimeDataSourceImpl(this._gateway);
  final RealtimeGateway _gateway;

  @override
  Stream<MessageChange> watch(String conversationId) => _gateway
      .watchTable('messages', filterColumn: 'conversation_id', filterValue: conversationId)
      .map((change) {
        final record = change.type == RealtimeEventType.delete ? change.oldRecord : change.newRecord;
        final id = record['id'] as String?;
        return switch (change.type) {
          RealtimeEventType.insert => MessageChange(MessageChangeType.inserted, messageId: id),
          RealtimeEventType.update => MessageChange(MessageChangeType.updated, messageId: id),
          RealtimeEventType.delete => MessageChange(MessageChangeType.deleted, messageId: id),
          RealtimeEventType.resync => const MessageChange(MessageChangeType.resync),
        };
      });
}
