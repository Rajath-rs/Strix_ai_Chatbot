import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecase/usecase.dart';
import '../repositories/ai_repository.dart';

class StreamMessageToAIUseCase extends UseCase<Stream<Either<Failure, String>>, StreamMessageToAIParams> {
  final AIRepository repository;

  StreamMessageToAIUseCase(this.repository);

  @override
  Future<Either<Failure, Stream<Either<Failure, String>>>> call(
    StreamMessageToAIParams params,
  ) {
    return Future.value(
      Right(
        repository.streamMessage(
          params.baseUrl,
          params.apiKey,
          params.model,
          params.messages,
        ),
      ),
    );
  }
}


class StreamMessageToAIParams {
  final String baseUrl;
  final String apiKey;
  final String model;
  final List<Map<String, String>> messages;

  StreamMessageToAIParams({
    required this.baseUrl,
    required this.apiKey,
    required this.model,
    required this.messages,
  });
}

