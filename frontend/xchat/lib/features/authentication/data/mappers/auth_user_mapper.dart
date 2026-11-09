import 'package:xchat/core/mappers/entity_mapper.dart';
import 'package:xchat/features/authentication/data/models/auth_user_model.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';

final class AuthUserMapper implements EntityMapper<AuthUserModel, AuthUser> {
  const AuthUserMapper();

  @override
  AuthUser toEntity(AuthUserModel model) => AuthUser(id: model.id, phone: model.phone);

  @override
  AuthUserModel toModel(AuthUser entity) => AuthUserModel(id: entity.id, phone: entity.phone);
}
