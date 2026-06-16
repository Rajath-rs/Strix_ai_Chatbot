import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/message.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<Message>>> getMessagesByConversationId(String conversationId);
  Future<Either<Failure, void>> saveMessage(Message message);
  Future<Either<Failure, void>> deleteMessagesByConversationId(String conversationId);
}
