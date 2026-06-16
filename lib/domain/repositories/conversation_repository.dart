import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/conversation.dart';

abstract class ConversationRepository {
  Future<Either<Failure, List<Conversation>>> getAllConversations();
  Future<Either<Failure, Conversation>> getConversationById(String id);
  Future<Either<Failure, void>> createConversation(Conversation conversation);
  Future<Either<Failure, void>> deleteConversation(String id);
  Future<Either<Failure, void>> updateConversation(Conversation conversation);
}
