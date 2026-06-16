import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversationsEvent extends ConversationEvent {
  const LoadConversationsEvent();
}

class CreateConversationEvent extends ConversationEvent {
  final String title;

  const CreateConversationEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class DeleteConversationEvent extends ConversationEvent {
  final String conversationId;

  const DeleteConversationEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class OpenConversationEvent extends ConversationEvent {
  final String conversationId;

  const OpenConversationEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}
