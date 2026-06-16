import 'package:equatable/equatable.dart';
import '../../../domain/entities/conversation.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

class ConversationLoading extends ConversationState {
  const ConversationLoading();
}

class ConversationLoaded extends ConversationState {
  final List<Conversation> conversations;

  const ConversationLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationEmpty extends ConversationState {
  const ConversationEmpty();
}

class ConversationCreated extends ConversationState {
  final Conversation conversation;

  const ConversationCreated(this.conversation);

  @override
  List<Object?> get props => [conversation];
}

class ConversationDeleted extends ConversationState {
  final String conversationId;

  const ConversationDeleted(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class ConversationOpened extends ConversationState {
  final Conversation conversation;

  const ConversationOpened(this.conversation);

  @override
  List<Object?> get props => [conversation];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object?> get props => [message];
}
