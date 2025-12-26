import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'animated_hand_gesture.dart';
import 'spotlight_painter.dart';
import 'models/gesture_type.dart';

/// A widget that overlays your UI with an interactive tutorial hint.
/// 
/// Users must perform the specified gesture on the actual UI to dismiss the overlay.
/// Perfect for first-time user experiences and feature discovery.
/// 
/// Example:
/// ```dart
/// FeatureHintOverlay(
///   message: "Swipe left to delete",
///   gesture: GestureType.swipeLeft,
///   child: YourWidget(),
///   onGestureCompleted: () {
///     print("User learned the gesture!");
///   },
/// )
/// ```
class FeatureHintOverlay extends StatefulWidget {
  /// The widget to overlay with the hint
  final Widget child;
  
  /// Message to display to the user
  final String message;
  
  /// The gesture type user must perform
  final GestureType gesture;
  
  /// Callback when user successfully performs the gesture
  final VoidCallback onGestureCompleted;
  
  /// Whether to show animated hand gesture
  final bool showHandAnimation;
  
  /// Whether to show the overlay (set to false to permanently hide)
  final bool showOverlay;
  
  /// Background color of the overlay
  final Color overlayColor;
  
  /// Text style for the message
  final TextStyle? messageStyle;
  
  /// Position of the message box
  final AlignmentGeometry messageAlignment;
  
  /// Minimum swipe velocity to trigger gesture (pixels per second)
  final double swipeVelocityThreshold;
  
  /// Duration for long press gesture
  final Duration longPressDuration;
  
  /// Optional key for widget to highlight (spotlight effect)
  final GlobalKey? targetKey;
  
  /// Padding around spotlight area
  final EdgeInsets spotlightPadding;
  
  const FeatureHintOverlay({
    Key? key,
    required this.child,
    required this.message,
    required this.gesture,
    required this.onGestureCompleted,
    this.showHandAnimation = true,
    this.showOverlay = true,
    this.overlayColor = const Color(0xBF000000),
    this.messageStyle,
    this.messageAlignment = Alignment.topCenter,
    this.swipeVelocityThreshold = 500.0,
    this.longPressDuration = const Duration(milliseconds: 500),
    this.targetKey,
    this.spotlightPadding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  State<FeatureHintOverlay> createState() => _FeatureHintOverlayState();
}

class _FeatureHintOverlayState extends State<FeatureHintOverlay> {
  bool _showOverlay = true;
  Offset? _gestureStart;
  DateTime? _pressStartTime;
  
  @override
  void initState() {
    super.initState();
    _showOverlay = widget.showOverlay;
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The actual widget (always visible and interactive)
        widget.child,
        
        // Tutorial overlay
        if (_showOverlay)
          _buildOverlay(),
      ],
    );
  }
  
  Widget _buildOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        // Handle different gesture types
        onHorizontalDragStart: _isHorizontalGesture ? _onDragStart : null,
        onHorizontalDragEnd: _isHorizontalGesture ? _onHorizontalDragEnd : null,
        onVerticalDragStart: _isVerticalGesture ? _onDragStart : null,
        onVerticalDragEnd: _isVerticalGesture ? _onVerticalDragEnd : null,
        onTapDown: widget.gesture == GestureType.tap ? _onTapDown : null,
        onLongPressStart: widget.gesture == GestureType.longPress ? _onLongPressStart : null,
        onLongPressEnd: widget.gesture == GestureType.longPress ? _onLongPressEnd : null,
        
        child: Stack(
          children: [
            // Dark overlay with optional spotlight
            _buildBackground(),
            
            // Message box
            _buildMessageBox(),
            
            // Animated hand gesture
            if (widget.showHandAnimation)
              _buildHandAnimation(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBackground() {
    if (widget.targetKey != null) {
      return CustomPaint(
        painter: SpotlightPainter(
          targetKey: widget.targetKey!,
          overlayColor: widget.overlayColor,
          spotlightPadding: widget.spotlightPadding,
        ),
        child: Container(),
      );
    }
    
    return Container(
      color: widget.overlayColor,
    );
  }
  
  Widget _buildMessageBox() {
    return Align(
      alignment: widget.messageAlignment,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            widget.message,
            style: widget.messageStyle ??
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  
  Widget _buildHandAnimation() {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - 30,
      top: MediaQuery.of(context).size.height / 2,
      child: AnimatedHandGesture(
        gesture: widget.gesture,
      ),
    );
  }
  
  bool get _isHorizontalGesture =>
      widget.gesture == GestureType.swipeLeft ||
      widget.gesture == GestureType.swipeRight;
  
  bool get _isVerticalGesture =>
      widget.gesture == GestureType.swipeUp ||
      widget.gesture == GestureType.swipeDown;
  
  void _onDragStart(DragStartDetails details) {
    _gestureStart = details.globalPosition;
  }
  
  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_gestureStart == null) return;
    
    final velocity = details.velocity.pixelsPerSecond.dx;
    
    if (widget.gesture == GestureType.swipeLeft &&
        velocity < -widget.swipeVelocityThreshold) {
      _onCorrectGesture();
    } else if (widget.gesture == GestureType.swipeRight &&
        velocity > widget.swipeVelocityThreshold) {
      _onCorrectGesture();
    }
    
    _gestureStart = null;
  }
  
  void _onVerticalDragEnd(DragEndDetails details) {
    if (_gestureStart == null) return;
    
    final velocity = details.velocity.pixelsPerSecond.dy;
    
    if (widget.gesture == GestureType.swipeUp &&
        velocity < -widget.swipeVelocityThreshold) {
      _onCorrectGesture();
    } else if (widget.gesture == GestureType.swipeDown &&
        velocity > widget.swipeVelocityThreshold) {
      _onCorrectGesture();
    }
    
    _gestureStart = null;
  }
  
  void _onTapDown(TapDownDetails details) {
    _onCorrectGesture();
  }
  
  void _onLongPressStart(LongPressStartDetails details) {
    _pressStartTime = DateTime.now();
  }
  
  void _onLongPressEnd(LongPressEndDetails details) {
    if (_pressStartTime != null) {
      final duration = DateTime.now().difference(_pressStartTime!);
      if (duration >= widget.longPressDuration) {
        _onCorrectGesture();
      }
    }
    _pressStartTime = null;
  }
  
  void _onCorrectGesture() {
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    // Hide overlay
    setState(() {
      _showOverlay = false;
    });
    
    // Notify completion
    widget.onGestureCompleted();
  }
}