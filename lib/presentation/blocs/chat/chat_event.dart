import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String conversationId;
  final String messageContent;

  const SendMessageEvent({
    required this.conversationId,
    required this.messageContent,
  });

  @override
  List<Object?> get props => [conversationId, messageContent];
}


class ClearChatEvent extends ChatEvent {
  const ClearChatEvent();
}

class LoadMessagesEvent extends ChatEvent {
  final String conversationId;

  const LoadMessagesEvent({
    required this.conversationId,
  });

  @override
  List<Object?> get props => [conversationId];
}

