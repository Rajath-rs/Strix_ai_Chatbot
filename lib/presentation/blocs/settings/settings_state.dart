import 'package:equatable/equatable.dart';
import '../../../domain/entities/ai_provider.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final List<AIProvider> providers;
  final AIProvider? currentProvider;

  const SettingsLoaded({
    required this.providers,
    this.currentProvider,
  });

  @override
  List<Object?> get props => [providers, currentProvider];
}

class ProviderUpdated extends SettingsState {
  final AIProvider provider;

  const ProviderUpdated(this.provider);

  @override
  List<Object?> get props => [provider];
}

class CurrentProviderSet extends SettingsState {
  final AIProvider provider;

  const CurrentProviderSet(this.provider);

  @override
  List<Object?> get props => [provider];
}

class ProviderDeleted extends SettingsState {
  final String providerId;

  const ProviderDeleted(this.providerId);

  @override
  List<Object?> get props => [providerId];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
