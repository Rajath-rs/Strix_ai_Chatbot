import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/remote/ai_client.dart';

class AIRepositoryImpl implements AIRepository {
  final AIClient aiClient;

  AIRepositoryImpl(this.aiClient);

  @override
  Future<Either<Failure, String>> sendMessage(
    String baseUrl,
    String apiKey,
    String model,
    List<Map<String, String>> messages,
  ) async {
    try {
      final response = await aiClient.sendMessage(baseUrl, apiKey, model, messages);
      return Right(response);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, String>> streamMessage(
    String baseUrl,
    String apiKey,
    String model,
    List<Map<String, String>> messages,
  ) {
    return aiClient.streamMessage(baseUrl, apiKey, model, messages).map<Either<Failure, String>>(
          (token) => Right(token),
        );
  }

}

