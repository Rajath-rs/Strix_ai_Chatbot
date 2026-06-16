import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/ai_provider.dart';
import '../datasources/local/settings_local_datasource.dart';
import '../models/ai_provider_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, bool>> isDarkMode() async {
    try {
      final settings = await localDataSource.getSettings();
      return Right(settings.isDarkMode);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setDarkMode(bool isDarkMode) async {
    try {
      await localDataSource.updateDarkMode(isDarkMode);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setCurrentProvider(String providerId) async {
    try {
      await localDataSource.setCurrentProvider(providerId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AIProvider?>> getCurrentProvider() async {
    try {
      final provider = await localDataSource.getCurrentProvider();
      return Right(provider?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AIProvider>>> getAllProviders() async {
    try {
      final providers = await localDataSource.getAllProviders();
      return Right(providers.map((p) => p.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveProvider(AIProvider provider) async {
    try {
      final model = AIProviderModel.fromEntity(provider);
      await localDataSource.saveProvider(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProvider(String providerId) async {
    try {
      await localDataSource.deleteProvider(providerId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
