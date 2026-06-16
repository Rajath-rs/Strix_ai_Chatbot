import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract class AIRepository {
  Future<Either<Failure, String>> sendMessage(
    String baseUrl,
    String apiKey,
    String model,
    List<Map<String, String>> messages,
  );

  Stream<Either<Failure, String>> streamMessage(
    String baseUrl,
    String apiKey,
    String model,
    List<Map<String, String>> messages,
  );
}

