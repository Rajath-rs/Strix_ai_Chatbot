import 'package:hive/hive.dart';
import '../../models/conversation_model.dart';

import '../../../core/errors/exceptions.dart';

abstract class ConversationLocalDataSource {
  Future<List<ConversationModel>> getAllConversations();
  Future<ConversationModel> getConversationById(String id);
  Future<void> saveConversation(ConversationModel conversation);
  Future<void> deleteConversation(String id);
  Future<void> updateConversation(ConversationModel conversation);
}

class ConversationLocalDataSourceImpl implements ConversationLocalDataSource {
  final Box<ConversationModel> _conversationBox;

  ConversationLocalDataSourceImpl(this._conversationBox);

  @override
  Future<List<ConversationModel>> getAllConversations() async {
    try {
      final conversations = _conversationBox.values.toList();
      conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return conversations;
    } catch (e) {
      throw CacheException('Failed to get conversations: $e');
    }
  }

  @override
  Future<ConversationModel> getConversationById(String id) async {
    try {
      final conversation = _conversationBox.values
          .firstWhere((c) => c.id == id);
      return conversation;
    } catch (e) {
      throw NotFoundException('Conversation with id $id not found');
    }
  }

  @override
  Future<void> saveConversation(ConversationModel conversation) async {
    try {
      await _conversationBox.put(conversation.id, conversation);
    } catch (e) {
      throw CacheException('Failed to save conversation: $e');
    }
  }

  @override
  Future<void> deleteConversation(String id) async {
    try {
      await _conversationBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete conversation: $e');
    }
  }

  @override
  Future<void> updateConversation(ConversationModel conversation) async {
    try {
      await _conversationBox.put(conversation.id, conversation);
    } catch (e) {
      throw CacheException('Failed to update conversation: $e');
    }
  }
}
