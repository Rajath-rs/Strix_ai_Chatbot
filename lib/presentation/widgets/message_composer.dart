import 'package:flutter/material.dart';

class MessageComposer extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;

  const MessageComposer({
    required this.onSendMessage,
    required this.isLoading,
    super.key,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}


class _MessageComposerState extends State<MessageComposer> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final bg = isDark ? const Color(0xFF141414) : Colors.white;
    final border = isDark ? Colors.white12 : Colors.black12;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !widget.isLoading,
                    minLines: 1,
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Message your AI assistant…',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white54
                            : Colors.black54,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 6),
                _SendButton(
                  isLoading: widget.isLoading,
                  color: primary,
                  onPressed: widget.isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _SendButton extends StatelessWidget {
  final bool isLoading;
  final Color color;
  final VoidCallback? onPressed;

  const _SendButton({
    required this.isLoading,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScale(
      duration: const Duration(milliseconds: 130),
      scale: onPressed == null ? 1.0 : 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
          color: isLoading ? color.withValues(alpha: 0.35) : color,

            shape: BoxShape.circle,
            boxShadow: [
              if (!isLoading)
                BoxShadow(
                  color: color.withValues(alpha: isDark ? 0.35 : 0.25),

                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

