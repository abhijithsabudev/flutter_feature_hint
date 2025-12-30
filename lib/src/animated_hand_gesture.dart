import 'package:flutter/material.dart';
import 'models/gesture_type.dart';

/// Animated gesture icon that demonstrates the required gesture
class AnimatedHandGesture extends StatefulWidget {
  /// The gesture type to animate
  final GestureType gesture;

  /// Optional custom widget to display instead of auto-detected icon.
  /// The custom widget should include its own styling, size, and color.
  final Widget? customIcon;

  const AnimatedHandGesture({Key? key, required this.gesture, this.customIcon})
    : super(key: key);

  @override
  State<AnimatedHandGesture> createState() => _AnimatedHandGestureState();
}

class _AnimatedHandGestureState extends State<AnimatedHandGesture>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animation = _getAnimationForGesture();
  }

  Animation<Offset> _getAnimationForGesture() {
    switch (widget.gesture) {
      case GestureType.swipeLeft:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-150, 0),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );

      case GestureType.swipeRight:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(150, 0),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );

      case GestureType.swipeUp:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -150),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );

      case GestureType.swipeDown:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 150),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );

      case GestureType.tap:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 10),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
        );

      case GestureType.longPress:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 5),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value,
          child: Opacity(
            opacity: 1 - (_controller.value * 0.3),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120, maxHeight: 120),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SingleChildScrollView(
                  child: widget.customIcon ?? _buildDefaultIcon(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the default icon based on gesture type with white color and 60px size
  Widget _buildDefaultIcon() {
    return Center(
      child: Icon(_getIconForGesture(), size: 60.0, color: Colors.white),
    );
  }

  IconData _getIconForGesture() {
    switch (widget.gesture) {
      case GestureType.swipeLeft:
      case GestureType.swipeRight:
      case GestureType.swipeUp:
      case GestureType.swipeDown:
        return Icons.swipe;
      case GestureType.tap:
        return Icons.touch_app;
      case GestureType.longPress:
        return Icons.touch_app;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
