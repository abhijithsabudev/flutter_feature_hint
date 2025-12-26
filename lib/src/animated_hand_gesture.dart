import 'package:flutter/material.dart';
import 'models/gesture_type.dart';

/// Animated hand icon that demonstrates the required gesture
class AnimatedHandGesture extends StatefulWidget {
  final GestureType gesture;
  final Color iconColor;
  final double iconSize;
  
  const AnimatedHandGesture({
    Key? key,
    required this.gesture,
    this.iconColor = Colors.white,
    this.iconSize = 60.0,
  }) : super(key: key);

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
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        
      case GestureType.swipeRight:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(150, 0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        
      case GestureType.swipeUp:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -150),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        
      case GestureType.swipeDown:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 150),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        
      case GestureType.tap:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 10),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticIn,
        ));
        
      case GestureType.longPress:
        return Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 5),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
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
            child: Icon(
              _getIconForGesture(),
              size: widget.iconSize,
              color: widget.iconColor,
            ),
          ),
        );
      },
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