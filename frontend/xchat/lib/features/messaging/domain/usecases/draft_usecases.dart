import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/services/clock.dart';
import 'package:xchat/core/usecases/usecase.dart';
import 'package:xchat/features/messaging/domain/entities/draft.dart';
import 'package:xchat/features/messaging/domain/repositories/draft_repository.dart';
import 'package:fpdart/fpdart.dart';

final class GetDraft implements UseCase<Draft?, String> {
  const GetDraft(this._repository);
  final DraftRepository _repository;

  @override
  Future<Either<Failure, Draft?>> call(String conversationId) => _repository.get(conversationId);
}

final class SaveDraftParams {
  const SaveDraftParams({required this.conversationId, required this.text});
  final String conversationId;
  final String text;
}

/// Saves the draft, or clears it when the text is blank.
final class SaveDraft implements UseCase<void, SaveDraftParams> {
  const SaveDraft(this._repository, this._clock);
  final DraftRepository _repository;
  final Clock _clock;

  @override
  Future<Either<Failure, void>> call(SaveDraftParams params) {
    if (params.text.trim().isEmpty) return _repository.clear(params.conversationId);
    return _repository.save(
      Draft(conversationId: params.conversationId, text: params.text, updatedAt: _clock.now()),
    );
  }
}

final class ClearDraft implements UseCase<void, String> {
  const ClearDraft(this._repository);
  final DraftRepository _repository;

  @override
  Future<Either<Failure, void>> call(String conversationId) => _repository.clear(conversationId);
}
