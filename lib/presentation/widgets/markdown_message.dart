import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class MarkdownMessage extends StatelessWidget {
  final String content;
  final DateTime timestamp;
  final bool isUser;

  const MarkdownMessage({
    required this.content,
    required this.timestamp,
    required this.isUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    final radius = BorderRadius.circular(22);
    final surface = isDarkMode ? const Color(0xFF1F1F1F) : Colors.grey.shade200;
    final cardBorder = isDarkMode ? Colors.white12 : Colors.black12;

    final bubbleColor = isUser
        ? (isDarkMode ? const Color(0xFF2563EB) : const Color(0xFF3B82F6))
        : surface;

    final textColor = isUser
        ? Colors.white
        : (isDarkMode ? Colors.white : Colors.black87);

    final subtitleColor = isUser
        ? Colors.white.withValues(alpha: 0.7)
        : (isDarkMode ? Colors.white.withValues(alpha: 0.7) : Colors.black54);


    Widget body;
    if (!isUser) {
      body = MarkdownBody(
        data: content,
        selectable: true,
        softLineBreak: true,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            color: textColor,
            fontSize: 14,
            height: 1.55,
          ),
          h1: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          h2: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          code: TextStyle(
            backgroundColor: isDarkMode ? Colors.white10 : Colors.black12,
            color: textColor,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
          codeblockDecoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
          blockquotePadding: const EdgeInsets.symmetric(horizontal: 12),
          blockquoteDecoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      body = Text(
        content,
        softWrap: true,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          height: 1.55,
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          final offset = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offset, child: child),
          );
        },
        child: Container(
          key: ValueKey('${isUser ? 'u' : 'a'}-${timestamp.millisecondsSinceEpoch}-${content.length}'),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: radius,
            border: isUser ? null : Border.all(color: cardBorder),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              body,
              const SizedBox(height: 6),
              Text(
                DateFormat('HH:mm').format(timestamp),
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

