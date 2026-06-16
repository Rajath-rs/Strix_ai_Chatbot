import 'package:hive/hive.dart';
import '../../models/message_model.dart';
import '../../../core/errors/exceptions.dart';

abstract class MessageLocalDataSource {
  Future<List<MessageModel>> getMessagesByConversationId(String conversationId);
  Future<void> saveMessage(MessageModel message);
  Future<void> deleteMessagesByConversationId(String conversationId);
}

class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  final Box<MessageModel> _messageBox;

  MessageLocalDataSourceImpl(this._messageBox);

  @override
  Future<List<MessageModel>> getMessagesByConversationId(String conversationId) async {
    try {
      final messages = _messageBox.values
          .where((m) => m.conversationId == conversationId)
          .toList();
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    } catch (e) {
      throw CacheException('Failed to get messages: $e');
    }
  }

  @override
  Future<void> saveMessage(MessageModel message) async {
    try {
      await _messageBox.put(message.id, message);
    } catch (e) {
      throw CacheException('Failed to save message: $e');
    }
  }

  @override
  Future<void> deleteMessagesByConversationId(String conversationId) async {
    try {
      final messages = _messageBox.values
          .where((m) => m.conversationId == conversationId)
          .toList();
      for (var message in messages) {
        await _messageBox.delete(message.id);
      }
    } catch (e) {
      throw CacheException('Failed to delete messages: $e');
    }
  }
}
