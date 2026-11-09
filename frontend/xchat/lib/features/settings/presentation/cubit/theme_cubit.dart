import 'package:bloc/bloc.dart';
import 'package:xchat/core/usecases/usecase.dart';
import 'package:xchat/features/settings/domain/entities/app_theme_mode.dart';
import 'package:xchat/features/settings/domain/usecases/theme_usecases.dart';

/// App-wide theme preference. The state IS the mode: the UI changes immediately and
/// persistence is best-effort (a storage failure must never block switching theme).
class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit({required GetThemeMode getThemeMode, required SetThemeMode setThemeMode})
      : _getThemeMode = getThemeMode,
        _setThemeMode = setThemeMode,
        super(AppThemeMode.system);

  final GetThemeMode _getThemeMode;
  final SetThemeMode _setThemeMode;

  Future<void> load() async {
    final result = await _getThemeMode(const NoParams());
    result.fold((_) {}, (mode) {
      if (!isClosed) emit(mode);
    });
  }

  Future<void> setMode(AppThemeMode mode) async {
    emit(mode);
    await _setThemeMode(mode);
  }
}
