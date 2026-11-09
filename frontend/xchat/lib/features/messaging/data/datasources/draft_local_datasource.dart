import 'package:xchat/features/messaging/data/models/draft_model.dart';

abstract interface class DraftLocalDataSource {
  Future<DraftModel?> get(String conversationId);
  Future<void> save(DraftModel model);
  Future<void> delete(String conversationId);
}
