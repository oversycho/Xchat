import 'package:fpdart/fpdart.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/settings/domain/entities/app_theme_mode.dart';

abstract interface class ThemeRepository {
  Future<Either<Failure, AppThemeMode>> load();
  Future<Either<Failure, void>> save(AppThemeMode mode);
}
