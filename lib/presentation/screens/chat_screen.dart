import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/conversation.dart';
import '../../presentation/blocs/chat/chat_bloc.dart';
import '../../presentation/blocs/chat/chat_event.dart';
import '../../presentation/blocs/chat/chat_state.dart';
import '../../domain/entities/message.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/markdown_message.dart';
import '../widgets/message_composer.dart';
import '../widgets/error_dialog.dart';
import '../widgets/typing_indicator_dots.dart';



class ChatScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatScreen({
    required this.conversation,
    super.key,
  });


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
      LoadMessagesEvent(
        conversationId: widget.conversation.id,
      ),
    );

  }



  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            widget.conversation.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        elevation: 1,
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            showErrorDialog(context, state.message);
          } else {
            if (_scrollController.hasClients) {
              _scrollToBottom();
            }
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            final messages =
                state is ChatMessagesReady ? state.messages : <Message>[];
            final isTyping = state is ChatMessagesReady ? state.isWaitingForResponse : false;

            final isDark = Theme.of(context).brightness == Brightness.dark;
            final bg = isDark ? const Color(0xFF0D0D0D) : Colors.grey.shade50;


            return Container(
              color: bg,
              child: Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    size: 54,
                                    color: Color(0xFF3B82F6),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Start a Conversation',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Ask anything and begin chatting with your AI assistant.',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: isDark ? Colors.white70 : Colors.black54,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              final isUser = msg.role == AppConstants.userRole;
                              return MarkdownMessage(
                                content: msg.content,
                                timestamp: msg.timestamp,
                                isUser: isUser,
                              );
                            },
                          ),
                  ),

                  if (isTyping)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, top: 4),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1F1F1F)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isDark ? Colors.white12 : Colors.black12,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TypingIndicatorDots(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Assistant is thinking',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: isDark ? Colors.white70 : Colors.black54,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Composer pinned at bottom.
                  Material(
                    color: Colors.transparent,
                    child: MessageComposer(
                      onSendMessage: (message) {
                        context.read<ChatBloc>().add(
                          SendMessageEvent(
                            conversationId: widget.conversation.id,
                            messageContent: message,
                          ),
                        );
                      },
                      isLoading: isTyping,
                    ),
                  ),

                  const SizedBox(height: 2),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final dynamic message;
  final bool isUser;

  ChatMessage({
    required this.message,
    required this.isUser,
  });
}
