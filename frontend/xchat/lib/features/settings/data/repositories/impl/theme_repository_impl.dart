import 'package:fpdart/fpdart.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/utils/guard.dart';
import 'package:xchat/features/settings/data/datasources/theme_local_datasource.dart';
import 'package:xchat/features/settings/domain/entities/app_theme_mode.dart';
import 'package:xchat/features/settings/domain/repositories/theme_repository.dart';

final class ThemeRepositoryImpl implements ThemeRepository {
  ThemeRepositoryImpl(this._local);
  final ThemeLocalDataSource _local;

  @override
  Future<Either<Failure, AppThemeMode>> load() => guard(() async {
    final stored = await _local.read();
    return AppThemeMode.values.asNameMap()[stored] ?? AppThemeMode.system;
  });

  @override
  Future<Either<Failure, void>> save(AppThemeMode mode) =>
      guard<void>(() => _local.write(mode.name));
}
