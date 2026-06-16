import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/settings_usecases.dart';
import 'theme_event.dart';
import '../../../core/usecase/usecase.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final IsDarkModeUseCase isDarkModeUseCase;
  final SetDarkModeUseCase setDarkModeUseCase;

  ThemeBloc({
    required this.isDarkModeUseCase,
    required this.setDarkModeUseCase,
  }) : super(const ThemeLoading()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(const ThemeLoading());

    final result = await isDarkModeUseCase(NoParams());

    result.fold(
      (failure) => emit(ThemeError(failure.message)),
      (isDarkMode) => emit(ThemeLoaded(isDarkMode)),
    );
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final currentState = state;
    if (currentState is ThemeLoaded) {
      final newMode = !currentState.isDarkMode;
      final result = await setDarkModeUseCase(SetDarkModeParams(newMode));

      result.fold(
        (failure) => emit(ThemeError(failure.message)),
        (_) => emit(ThemeLoaded(newMode)),
      );
    }
  }

  Future<void> _onSetTheme(
    SetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final result = await setDarkModeUseCase(SetDarkModeParams(event.isDarkMode));

    result.fold(
      (failure) => emit(ThemeError(failure.message)),
      (_) => emit(ThemeLoaded(event.isDarkMode)),
    );
  }
}
