import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/conversation.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ConversationTile({
    required this.conversation,
    required this.onTap,
    this.onDelete,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(conversation.title),
      subtitle: Text(
        DateFormat('MMM dd, yyyy HH:mm').format(conversation.updatedAt),
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: onDelete,
            child: const Text('Delete'),
          ),
        ],
      ),

      onTap: onTap,
    );
  }
}
