import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/ai_provider.dart';
import '../repositories/settings_repository.dart';

class IsDarkModeUseCase extends UseCase<bool, NoParams> {
  final SettingsRepository repository;

  IsDarkModeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.isDarkMode();
  }
}

class SetDarkModeUseCase extends UseCase<void, SetDarkModeParams> {
  final SettingsRepository repository;

  SetDarkModeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SetDarkModeParams params) {
    return repository.setDarkMode(params.isDarkMode);
  }
}

class SetCurrentProviderUseCase extends UseCase<void, SetCurrentProviderParams> {
  final SettingsRepository repository;

  SetCurrentProviderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SetCurrentProviderParams params) {
    return repository.setCurrentProvider(params.providerId);
  }
}

class GetCurrentProviderUseCase extends UseCase<AIProvider?, NoParams> {
  final SettingsRepository repository;

  GetCurrentProviderUseCase(this.repository);

  @override
  Future<Either<Failure, AIProvider?>> call(NoParams params) {
    return repository.getCurrentProvider();
  }
}

class GetAllProvidersUseCase extends UseCase<List<AIProvider>, NoParams> {
  final SettingsRepository repository;

  GetAllProvidersUseCase(this.repository);

  @override
  Future<Either<Failure, List<AIProvider>>> call(NoParams params) {
    return repository.getAllProviders();
  }
}

class SaveProviderUseCase extends UseCase<void, SaveProviderParams> {
  final SettingsRepository repository;

  SaveProviderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveProviderParams params) {
    return repository.saveProvider(params.provider);
  }
}

class DeleteProviderUseCase extends UseCase<void, DeleteProviderParams> {
  final SettingsRepository repository;

  DeleteProviderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProviderParams params) {
    return repository.deleteProvider(params.providerId);
  }
}

class SetDarkModeParams {
  final bool isDarkMode;

  SetDarkModeParams(this.isDarkMode);
}

class SetCurrentProviderParams {
  final String providerId;

  SetCurrentProviderParams(this.providerId);
}

class SaveProviderParams {
  final AIProvider provider;

  SaveProviderParams(this.provider);
}

class DeleteProviderParams {
  final String providerId;

  DeleteProviderParams(this.providerId);
}
