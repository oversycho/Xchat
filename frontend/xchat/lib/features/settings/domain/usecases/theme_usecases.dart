import 'package:fpdart/fpdart.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/usecases/usecase.dart';
import 'package:xchat/features/settings/domain/entities/app_theme_mode.dart';
import 'package:xchat/features/settings/domain/repositories/theme_repository.dart';

final class GetThemeMode implements UseCase<AppThemeMode, NoParams> {
  const GetThemeMode(this._repository);
  final ThemeRepository _repository;

  @override
  Future<Either<Failure, AppThemeMode>> call(NoParams params) => _repository.load();
}

final class SetThemeMode implements UseCase<void, AppThemeMode> {
  const SetThemeMode(this._repository);
  final ThemeRepository _repository;

  @override
  Future<Either<Failure, void>> call(AppThemeMode mode) => _repository.save(mode);
}
