import 'package:flutter/material.dart';

/// A lightweight shimmer effect that can wrap any widget.
///
/// This is a small, dependency-free alternative to the `shimmer` package.
class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final Color baseColor;
  final Color highlightColor;

  const Shimmer({
    super.key,
    required this.child,
    this.period = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _controller.value;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final gradient = LinearGradient(
          begin: Alignment(-2 + progress * 4, 0),
          end: Alignment(-1 + progress * 4, 0),
          colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
          stops: const [0.2, 0.5, 0.8],
        );

        return ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(bounds),
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
