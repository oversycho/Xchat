import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/messaging/domain/entities/draft.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DraftRepository {
  Future<Either<Failure, Draft?>> get(String conversationId);
  Future<Either<Failure, void>> save(Draft draft);
  Future<Either<Failure, void>> clear(String conversationId);
}
