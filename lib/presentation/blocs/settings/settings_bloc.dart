import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/usecases/settings_usecases.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/entities/ai_provider.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetAllProvidersUseCase getAllProvidersUseCase;
  final GetCurrentProviderUseCase getCurrentProviderUseCase;
  final SaveProviderUseCase saveProviderUseCase;
  final SetCurrentProviderUseCase setCurrentProviderUseCase;
  final DeleteProviderUseCase deleteProviderUseCase;

  SettingsBloc({
    required this.getAllProvidersUseCase,
    required this.getCurrentProviderUseCase,
    required this.saveProviderUseCase,
    required this.setCurrentProviderUseCase,
    required this.deleteProviderUseCase,
  }) : super(const SettingsLoading()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateProviderEvent>(_onUpdateProvider);
    on<SetCurrentProviderEvent>(_onSetCurrentProvider);
    on<DeleteProviderEvent>(_onDeleteProvider);
    on<LoadProvidersEvent>(_onLoadProviders);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final providersResult = await getAllProvidersUseCase(NoParams());
    final currentProviderResult = await getCurrentProviderUseCase(NoParams());

    providersResult.fold(
      (failure) => emit(SettingsError(failure.message)),
      (providers) {
        currentProviderResult.fold(
          (failure) => emit(SettingsError(failure.message)),
          (currentProvider) {
            emit(SettingsLoaded(
              providers: providers,
              currentProvider: currentProvider,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadProviders(
    LoadProvidersEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await getAllProvidersUseCase(NoParams());

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (providers) {
        final currentState = state;
        final currentProvider = currentState is SettingsLoaded ? currentState.currentProvider : null;
        emit(SettingsLoaded(
          providers: providers,
          currentProvider: currentProvider,
        ));
      },
    );
  }

  Future<void> _onUpdateProvider(
    UpdateProviderEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final provider = event.provider.id.isEmpty
          ? AIProvider(
              id: const Uuid().v4(),
              providerName: event.provider.providerName,
              baseUrl: event.provider.baseUrl,
              model: event.provider.model,
              apiKey: event.provider.apiKey,
            )
          : event.provider;

      final result = await saveProviderUseCase(SaveProviderParams(provider));

      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) => emit(ProviderUpdated(provider)),
      );

      add(const LoadProvidersEvent());
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onSetCurrentProvider(
    SetCurrentProviderEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Debug log: provider selection received
    // ignore: avoid_print
    print('[SettingsBloc] SetCurrentProviderEvent received: providerId=${event.providerId}');

    final result = await setCurrentProviderUseCase(
      SetCurrentProviderParams(event.providerId),
    );

    await result.fold(
      (failure) async {
        // ignore: avoid_print
        print('[SettingsBloc] setCurrentProviderUseCase failed: ${failure.message}');
        emit(SettingsError(failure.message));
      },
      (_) async {
        // ignore: avoid_print
        print('[SettingsBloc] Hive currentProviderId save completed');

        // Emit immediately so SettingsScreen rebuilds based on Bloc state.
        final currentProviderResult = await getCurrentProviderUseCase(NoParams());
        final providersResult = await getAllProvidersUseCase(NoParams());

        providersResult.fold(
          (failure) {
            // ignore: avoid_print
            print('[SettingsBloc] getAllProvidersUseCase failed after selection: ${failure.message}');
            emit(SettingsError(failure.message));
          },
          (providers) {
            currentProviderResult.fold(
              (failure) {
                // ignore: avoid_print
                print('[SettingsBloc] getCurrentProviderUseCase failed after selection: ${failure.message}');
                emit(SettingsError(failure.message));
              },
              (provider) {
                // ignore: avoid_print
                print('[SettingsBloc] Emitting SettingsLoaded after selection. currentProviderId=${provider?.id}');
                emit(SettingsLoaded(
                  providers: providers,
                  currentProvider: provider,
                ));
              },
            );
          },
        );
      },
    );
  }




  Future<void> _onDeleteProvider(
    DeleteProviderEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await deleteProviderUseCase(
      DeleteProviderParams(event.providerId),
    );

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(ProviderDeleted(event.providerId)),
    );

    add(const LoadProvidersEvent());
  }
}
