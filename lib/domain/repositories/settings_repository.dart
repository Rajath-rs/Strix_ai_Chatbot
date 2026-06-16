import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/ai_provider.dart';

abstract class SettingsRepository {
  Future<Either<Failure, bool>> isDarkMode();
  Future<Either<Failure, void>> setDarkMode(bool isDarkMode);
  Future<Either<Failure, void>> setCurrentProvider(String providerId);
  Future<Either<Failure, AIProvider?>> getCurrentProvider();
  Future<Either<Failure, List<AIProvider>>> getAllProviders();
  Future<Either<Failure, void>> saveProvider(AIProvider provider);
  Future<Either<Failure, void>> deleteProvider(String providerId);
}
