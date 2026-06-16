import 'package:equatable/equatable.dart';
import '../../../domain/entities/ai_provider.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class UpdateProviderEvent extends SettingsEvent {
  final AIProvider provider;

  const UpdateProviderEvent(this.provider);

  @override
  List<Object?> get props => [provider];
}

class SetCurrentProviderEvent extends SettingsEvent {
  final String providerId;

  const SetCurrentProviderEvent(this.providerId);

  @override
  List<Object?> get props => [providerId];
}

class DeleteProviderEvent extends SettingsEvent {
  final String providerId;

  const DeleteProviderEvent(this.providerId);

  @override
  List<Object?> get props => [providerId];
}

class LoadProvidersEvent extends SettingsEvent {
  const LoadProvidersEvent();
}
