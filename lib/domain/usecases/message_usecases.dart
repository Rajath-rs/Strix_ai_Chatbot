import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/message.dart';
import '../repositories/message_repository.dart';

class GetMessagesByConversationIdUseCase extends UseCase<List<Message>, GetMessagesByConversationIdParams> {
  final MessageRepository repository;

  GetMessagesByConversationIdUseCase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesByConversationIdParams params) {
    return repository.getMessagesByConversationId(params.conversationId);
  }
}

class SaveMessageUseCase extends UseCase<void, SaveMessageParams> {
  final MessageRepository repository;

  SaveMessageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveMessageParams params) {
    return repository.saveMessage(params.message);
  }
}

class DeleteMessagesByConversationIdUseCase extends UseCase<void, DeleteMessagesByConversationIdParams> {
  final MessageRepository repository;

  DeleteMessagesByConversationIdUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteMessagesByConversationIdParams params) {
    return repository.deleteMessagesByConversationId(params.conversationId);
  }
}

class GetMessagesByConversationIdParams {
  final String conversationId;

  GetMessagesByConversationIdParams(this.conversationId);
}

class SaveMessageParams {
  final Message message;

  SaveMessageParams(this.message);
}

class DeleteMessagesByConversationIdParams {
  final String conversationId;

  DeleteMessagesByConversationIdParams(this.conversationId);
}
