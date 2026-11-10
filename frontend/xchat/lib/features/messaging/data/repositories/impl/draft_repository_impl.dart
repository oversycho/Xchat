import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/mappers/entity_mapper.dart';
import 'package:xchat/core/utils/guard.dart';
import 'package:xchat/features/messaging/data/datasources/draft_local_datasource.dart';
import 'package:xchat/features/messaging/data/models/draft_model.dart';
import 'package:xchat/features/messaging/domain/entities/draft.dart';
import 'package:xchat/features/messaging/domain/repositories/draft_repository.dart';
import 'package:fpdart/fpdart.dart';

final class DraftRepositoryImpl implements DraftRepository {
  DraftRepositoryImpl({
    required DraftLocalDataSource local,
    required EntityMapper<DraftModel, Draft> mapper,
  }) : _local = local,
       _mapper = mapper;

  final DraftLocalDataSource _local;
  final EntityMapper<DraftModel, Draft> _mapper;

  @override
  Future<Either<Failure, Draft?>> get(String conversationId) => guard<Draft?>(() async {
    final model = await _local.get(conversationId);
    return model == null ? null : _mapper.toEntity(model);
  });

  @override
  Future<Either<Failure, void>> save(Draft draft) =>
      guard<void>(() => _local.save(_mapper.toModel(draft)));

  @override
  Future<Either<Failure, void>> clear(String conversationId) =>
      guard<void>(() => _local.delete(conversationId));
}
