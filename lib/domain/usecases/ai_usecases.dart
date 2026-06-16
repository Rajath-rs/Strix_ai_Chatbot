import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecase/usecase.dart';
import '../repositories/ai_repository.dart';

class SendMessageToAIUseCase extends UseCase<String, SendMessageToAIParams> {
  final AIRepository repository;

  SendMessageToAIUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendMessageToAIParams params) {
    return repository.sendMessage(
      params.baseUrl,
      params.apiKey,
      params.model,
      params.messages,
    );
  }
}

class SendMessageToAIParams {
  final String baseUrl;
  final String apiKey;
  final String model;
  final List<Map<String, String>> messages;

  SendMessageToAIParams({
    required this.baseUrl,
    required this.apiKey,
    required this.model,
    required this.messages,
  });
}

