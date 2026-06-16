import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/message_repository.dart';
import '../../domain/entities/message.dart';
import '../datasources/local/message_local_datasource.dart';
import '../models/message_model.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageLocalDataSource localDataSource;

  MessageRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Message>>> getMessagesByConversationId(
    String conversationId,
  ) async {
    try {
      final messages = await localDataSource.getMessagesByConversationId(conversationId);
      return Right(messages.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessage(Message message) async {
    try {
      final model = MessageModel(
        id: const Uuid().v4(),
        conversationId: message.conversationId,
        role: message.role,
        content: message.content,
        timestamp: DateTime.now(),
      );
      await localDataSource.saveMessage(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessagesByConversationId(String conversationId) async {
    try {
      await localDataSource.deleteMessagesByConversationId(conversationId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
