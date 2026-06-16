import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

class ThemeLoading extends ThemeState {
  const ThemeLoading() : super(false);
}

class ThemeLoaded extends ThemeState {
  const ThemeLoaded(super.isDarkMode);
}


class ThemeError extends ThemeState {
  final String message;

  const ThemeError(this.message) : super(false);

  @override
  List<Object?> get props => [message];
}
