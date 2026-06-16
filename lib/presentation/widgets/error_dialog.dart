import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    required this.message,
    this.onRetry,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry?.call();
            },
            child: const Text('Retry'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}

void showErrorDialog(BuildContext context, String message, {VoidCallback? onRetry}) {
  showDialog(
    context: context,
    builder: (context) => ErrorDialog(
      message: message,
      onRetry: onRetry,
    ),
  );
}
