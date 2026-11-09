import 'package:fpdart/fpdart.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/mappers/entity_mapper.dart';
import 'package:xchat/core/utils/guard.dart';
import 'package:xchat/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:xchat/features/authentication/data/models/auth_user_model.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';
import 'package:xchat/features/authentication/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required EntityMapper<AuthUserModel, AuthUser> mapper,
  })  : _remote = remote,
        _mapper = mapper;

  final AuthRemoteDataSource _remote;
  final EntityMapper<AuthUserModel, AuthUser> _mapper;

  AuthUser? _entity(AuthUserModel? model) => model == null ? null : _mapper.toEntity(model);

  @override
  Stream<AuthUser?> watchAuthState() => _remote.watchUser().map(_entity);

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() => guard(() async => _entity(_remote.currentUser));

  @override
  Future<Either<Failure, void>> sendOtp(String phone) => guard<void>(() => _remote.sendOtp(phone));

  @override
  Future<Either<Failure, AuthUser>> verifyOtp({required String phone, required String code}) =>
      guard(() async => _mapper.toEntity(await _remote.verifyOtp(phone: phone, code: code)));

  @override
  Future<Either<Failure, void>> signOut() => guard<void>(_remote.signOut);

  @override
  Future<Either<Failure, void>> deleteAccount() => guard<void>(_remote.deleteAccount);
}
