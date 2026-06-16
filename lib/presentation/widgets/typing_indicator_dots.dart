import 'package:flutter/material.dart';

class TypingIndicatorDots extends StatefulWidget {
  final Color? color;
  final double dotSize;
  final Duration duration;

  const TypingIndicatorDots({
    super.key,
    this.color,
    this.dotSize = 8,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  State<TypingIndicatorDots> createState() => _TypingIndicatorDotsState();
}

class _TypingIndicatorDotsState extends State<TypingIndicatorDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.5, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: _Dot(
              color: color,
              size: widget.dotSize,
              delay: i,
              controller: _controller,
            ),
          );
        }),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  final int delay;
  final AnimationController controller;

  const _Dot({
    required this.color,
    required this.size,
    required this.delay,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Staggered scale animation.
    final totalDots = 3;
    final begin = delay / totalDots;
    final end = (delay + 1) / totalDots;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = (controller.value - begin) / (end - begin);
        final clamped = t.clamp(0.0, 1.0);
        final scale = 0.75 + (1 - (1 - clamped) * (1 - clamped)) * 0.55;
        final opacity = 0.45 + clamped * 0.55;

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

