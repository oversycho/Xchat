import 'package:flutter_test/flutter_test.dart';
import 'package:xchat/features/messaging/data/mappers/message_mapper.dart';
import 'package:xchat/features/messaging/data/models/attachment_model.dart';
import 'package:xchat/features/messaging/data/models/message_model.dart';
import 'package:xchat/features/messaging/domain/entities/attachment.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';

void main() {
  const mapper = MessageMapper();

  MessageModel model({String type = 'text', String status = 'sent', List<AttachmentModel> attachments = const []}) =>
      MessageModel(
        id: 'm1',
        conversationId: 'c1',
        senderId: 'u1',
        type: type,
        status: status,
        createdAt: DateTime.utc(2026, 1, 1),
        text: 'hi',
        attachments: attachments,
      );

  test('maps the snake_case wire format used by the database to Dart enums', () {
    final entity = mapper.toEntity(
      model(
        type: 'video_note',
        attachments: const [
          AttachmentModel(id: 'a1', kind: 'video_note', storagePath: 'c1/u/x.mp4', mimeType: 'video/mp4', sizeBytes: 10),
        ],
      ),
    );
    expect(entity.type, MessageType.videoNote);
    expect(entity.attachments.single.kind, AttachmentKind.videoNote);
  });

  test('writes enums back in snake_case', () {
    final back = mapper.toModel(mapper.toEntity(model(type: 'video_note')));
    expect(back.type, 'video_note');
  });

  test('unknown server values degrade safely instead of crashing', () {
    final entity = mapper.toEntity(model(type: 'something_new', status: 'weird'));
    expect(entity.type, MessageType.system);
    expect(entity.status, MessageStatus.sent);
  });
}
