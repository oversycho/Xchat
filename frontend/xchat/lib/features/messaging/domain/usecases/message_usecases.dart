import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/usecases/usecase.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:xchat/features/messaging/domain/repositories/message_repository.dart';
import 'package:fpdart/fpdart.dart';

final class WatchMessages {
  const WatchMessages(this._repository);
  final MessageRepository _repository;

  Stream<List<Message>> call(String conversationId) => _repository.watchMessages(conversationId);
}

final class RefreshLatestMessages implements UseCase<void, String> {
  const RefreshLatestMessages(this._repository);
  final MessageRepository _repository;

  @override
  Future<Either<Failure, void>> call(String conversationId) =>
      _repository.refreshLatest(conversationId);
}

final class LoadOlderParams {
  const LoadOlderParams(this.conversationId, {this.limit = 30});
  final String conversationId;
  final int limit;
}

final class LoadOlderMessages implements UseCase<PageResult, LoadOlderParams> {
  const LoadOlderMessages(this._repository);
  final MessageRepository _repository;

  @override
  Future<Either<Failure, PageResult>> call(LoadOlderParams params) =>
      _repository.loadOlder(params.conversationId, limit: params.limit);
}

final class EditMessageParams {
  const EditMessageParams({required this.messageId, required this.newText});
  final String messageId;
  final String newText;
}

final class EditMessage implements UseCase<void, EditMessageParams> {
  const EditMessage(this._repository);
  final MessageRepository _repository;

  static const maxTextLength = 4096;

  @override
  Future<Either<Failure, void>> call(EditMessageParams params) async {
    final text = params.newText.trim();
    if (text.isEmpty) return Either.left(const ValidationFailure('Message is empty'));
    if (text.length > maxTextLength)
      return Either.left(const ValidationFailure('Message is too long'));
    return _repository.edit(params.messageId, text);
  }
}

final class DeleteMessage implements UseCase<void, String> {
  const DeleteMessage(this._repository);
  final MessageRepository _repository;

  @override
  Future<Either<Failure, void>> call(String messageId) => _repository.delete(messageId);
}

final class ReactToMessageParams {
  const ReactToMessageParams({required this.messageId, required this.emoji, required this.add});
  final String messageId;
  final String emoji;
  final bool add;
}

final class ReactToMessage implements UseCase<void, ReactToMessageParams> {
  const ReactToMessage(this._repository);
  final MessageRepository _repository;

  @override
  Future<Either<Failure, void>> call(ReactToMessageParams params) =>
      _repository.setReaction(messageId: params.messageId, emoji: params.emoji, add: params.add);
}

final class MarkMessagesRead implements UseCase<void, List<String>> {
  const MarkMessagesRead(this._repository);
  final MessageRepository _repository;

  @override
  Future<Either<Failure, void>> call(List<String> messageIds) =>
      _repository.markRead(messageIds: messageIds);
}

final class SubscribeToConversation implements UseCase<void, String> {
  const SubscribeToConversation(this._repository);
  final MessageRepository _repository;

  @override
  Future<Either<Failure, void>> call(String conversationId) =>
      _repository.startRealtime(conversationId);
}

final class UnsubscribeFromConversation implements UseCase<void, String> {
  const UnsubscribeFromConversation(this._repository);
  final MessageRepository _repository;

  @override
  Future<Either<Failure, void>> call(String conversationId) =>
      _repository.stopRealtime(conversationId);
}
