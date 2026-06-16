import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/conversation_repository.dart';

class GetAllConversationsUseCase extends UseCase<List<Conversation>, NoParams> {
  final ConversationRepository repository;

  GetAllConversationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Conversation>>> call(NoParams params) {
    return repository.getAllConversations();
  }
}

class GetConversationByIdUseCase extends UseCase<Conversation, GetConversationByIdParams> {
  final ConversationRepository repository;

  GetConversationByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Conversation>> call(GetConversationByIdParams params) {
    return repository.getConversationById(params.id);
  }
}

class CreateConversationUseCase extends UseCase<void, CreateConversationParams> {
  final ConversationRepository repository;

  CreateConversationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateConversationParams params) {
    return repository.createConversation(params.conversation);
  }
}

class DeleteConversationUseCase extends UseCase<void, DeleteConversationParams> {
  final ConversationRepository repository;

  DeleteConversationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteConversationParams params) {
    return repository.deleteConversation(params.id);
  }
}

class UpdateConversationUseCase extends UseCase<void, UpdateConversationParams> {
  final ConversationRepository repository;

  UpdateConversationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateConversationParams params) {
    return repository.updateConversation(params.conversation);
  }
}

class GetConversationByIdParams {
  final String id;

  GetConversationByIdParams(this.id);
}

class CreateConversationParams {
  final Conversation conversation;

  CreateConversationParams(this.conversation);
}

class DeleteConversationParams {
  final String id;

  DeleteConversationParams(this.id);
}

class UpdateConversationParams {
  final Conversation conversation;

  UpdateConversationParams(this.conversation);
}
