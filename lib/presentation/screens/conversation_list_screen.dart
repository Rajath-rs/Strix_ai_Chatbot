import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/blocs/conversation/conversation_bloc.dart';
import '../../presentation/blocs/conversation/conversation_event.dart';
import '../../presentation/blocs/conversation/conversation_state.dart';
import '../../presentation/blocs/theme/theme_bloc.dart';
import '../../presentation/blocs/theme/theme_event.dart';
import '../../presentation/blocs/theme/theme_state.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_dialog.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});


  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ConversationBloc>().add(const LoadConversationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strix AI Chatbot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state is ThemeLoaded && state.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(const ToggleThemeEvent());
                },
              );
            },
          ),
        ],
      ),
      body: BlocListener<ConversationBloc, ConversationState>(
        listener: (context, state) {
          if (state is ConversationError) {
            // ignore: use_build_context_synchronously
            showErrorDialog(context, state.message);

          } else if (state is ConversationCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Conversation created')),
            );
            context.read<ConversationBloc>().add(const LoadConversationsEvent());
          } else if (state is ConversationDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Conversation deleted')),
            );
            context.read<ConversationBloc>().add(const LoadConversationsEvent());
          } else if (state is ConversationOpened) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(conversation: state.conversation),
              ),
            ).then((_) {
              if (!mounted) return;
              context.read<ConversationBloc>().add(const LoadConversationsEvent());
            });
          }

        },
        child: BlocBuilder<ConversationBloc, ConversationState>(
          builder: (context, state) {
            if (state is ConversationLoading) {
              return const LoadingIndicator(message: 'Loading conversations...');
            } else if (state is ConversationEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No conversations yet'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _createNewConversation,
                      icon: const Icon(Icons.add),
                      label: const Text('Create new conversation'),
                    ),
                  ],
                ),
              );
            } else if (state is ConversationLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ConversationBloc>().add(const LoadConversationsEvent());
                },
                child: ListView.builder(
                  itemCount: state.conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = state.conversations[index];
                    return ConversationTile(
                      conversation: conversation,
                      onTap: () {
                        context.read<ConversationBloc>().add(
                          OpenConversationEvent(conversation.id),
                        );
                      },
                      onDelete: () {
                        context.read<ConversationBloc>().add(
                          DeleteConversationEvent(conversation.id),
                        );
                      },
                    );
                  },
                ),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewConversation,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createNewConversation() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('New Conversation'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Conversation title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<ConversationBloc>().add(
                    CreateConversationEvent(controller.text),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
