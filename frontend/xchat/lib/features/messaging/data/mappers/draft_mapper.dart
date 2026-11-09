import 'package:xchat/core/mappers/entity_mapper.dart';
import 'package:xchat/features/messaging/data/models/draft_model.dart';
import 'package:xchat/features/messaging/domain/entities/draft.dart';

final class DraftMapper implements EntityMapper<DraftModel, Draft> {
  const DraftMapper();

  @override
  Draft toEntity(DraftModel m) =>
      Draft(conversationId: m.conversationId, text: m.text, updatedAt: m.updatedAt);

  @override
  DraftModel toModel(Draft e) =>
      DraftModel(conversationId: e.conversationId, text: e.text, updatedAt: e.updatedAt);
}
