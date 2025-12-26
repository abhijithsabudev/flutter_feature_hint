import 'package:flutter/material.dart';
import 'animated_hand_gesture.dart';
import 'models/gesture_type.dart';

/// A widget that overlays your UI with an animated hint tutorial.
///
/// Automatically plays the animation for a specified duration and then closes.
/// Perfect for first-time user experiences and feature discovery.
///
/// Example:
/// ```dart
/// FeatureHintOverlay(
///   message: "Swipe left to delete",
///   gesture: GestureType.swipeLeft,
///   duration: Duration(seconds: 5),
///   child: YourWidget(),
///   onCompleted: () {
///     print("Hint animation completed!");
///   },
/// )
/// ```
class FeatureHintOverlay extends StatefulWidget {
  /// The widget to overlay with the hint
  final Widget child;

  /// Message widget to display to the user
  final Widget message;

  /// The gesture type to animate
  final GestureType gesture;

  /// Duration to show the overlay animation
  final Duration duration;

  /// Whether to play the animation or not
  final bool shouldPlay;

  /// Callback when animation completes and overlay closes
  final VoidCallback? onCompleted;

  /// Whether to show animated hand gesture
  final bool showHandAnimation;

  /// Background color of the overlay
  final Color overlayColor;

  /// Position of the message box on screen
  final AlignmentGeometry messageAlignment;

  /// Custom icon to display instead of hand gesture
  final IconData? customIcon;

  /// Size of the icon/animation
  final double iconSize;

  /// Color of the icon
  final Color iconColor;

  const FeatureHintOverlay({
    Key? key,
    required this.child,
    required this.message,
    required this.gesture,
    this.duration = const Duration(seconds: 4),
    this.shouldPlay = true,
    this.onCompleted,
    this.showHandAnimation = true,
    this.overlayColor = const Color(0xBF000000),
    this.messageAlignment = Alignment.topCenter,
    this.customIcon,
    this.iconSize = 60.0,
    this.iconColor = Colors.white,
  }) : assert(duration > Duration.zero, 'Duration must be positive'),
       assert(iconSize > 0, 'Icon size must be positive'),
       super(key: key);

  @override
  State<FeatureHintOverlay> createState() => _FeatureHintOverlayState();
}

class _FeatureHintOverlayState extends State<FeatureHintOverlay>
    with SingleTickerProviderStateMixin {
  late bool _showOverlay;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final GlobalKey _childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeOverlay();
  }

  /// Initializes the overlay display and animation.
  void _initializeOverlay() {
    _showOverlay = widget.shouldPlay;

    // Initialize fade animation controller for smooth transitions
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    if (_showOverlay) {
      // Wait for first frame to be laid out before showing overlay
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _fadeController.forward();
          _scheduleOverlayDismiss();
        }
      });
    }
  }

  /// Schedules the overlay to automatically close after [duration].
  void _scheduleOverlayDismiss() {
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismissOverlay();
      }
    });
  }

  /// Dismisses the overlay with a fade-out animation.
  Future<void> _dismissOverlay() async {
    await _fadeController.reverse();
    if (mounted) {
      setState(() {
        _showOverlay = false;
      });
      widget.onCompleted?.call();
    }
  }

  /// Gets the position and size of the wrapped child widget.
  Offset _getChildPosition() {
    final RenderBox? renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      return renderBox.localToGlobal(Offset.zero);
    }
    return Offset.zero;
  }

  /// Gets the size of the wrapped child widget.
  Size _getChildSize() {
    final RenderBox? renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      return renderBox.size;
    }
    return Size.zero;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The actual widget - always interactive and responsive, tracked for overlay positioning
        KeyedSubtree(key: _childKey, child: widget.child),

        // Full-screen tutorial overlay with fade transition
        if (_showOverlay)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Positioned.fill(child: _buildFullScreenOverlay()),
          ),
      ],
    );
  }

  /// Builds a full-screen overlay with semi-transparent background and positioned hint.
  Widget _buildFullScreenOverlay() {
    return Stack(
      children: [
        // Semi-transparent background covering entire screen
        Container(color: widget.overlayColor),

        // Message box positioned according to messageAlignment
        _buildMessageBox(),

        // Animated gesture icon positioned exactly over wrapped widget
        if (widget.showHandAnimation) _buildAnimatedGestureWithTransform(),
      ],
    );
  }

  /// Builds the animated gesture icon using Transform to position it over the wrapped widget.
  Widget _buildAnimatedGestureWithTransform() {
    // Get child render box
    final childRenderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;

    if (childRenderBox == null || !childRenderBox.hasSize) {
      // Show icon in center as fallback
      return Center(
        child: AnimatedHandGesture(
          gesture: widget.gesture,
          iconColor: widget.iconColor,
          iconSize: widget.iconSize,
          customIcon: widget.customIcon,
        ),
      );
    }

    try {
      // Get child position relative to the root widget
      final childPosition = childRenderBox.localToGlobal(Offset.zero);
      final childSize = childRenderBox.size;

      // Calculate center position of the child widget
      final childCenterX = childPosition.dx + (childSize.width / 2);
      final childCenterY = childPosition.dy + (childSize.height / 2);

      // Get the overlay's position to calculate relative offset
      final mediaQuery = MediaQuery.of(_childKey.currentContext!);

      // Center of screen
      final screenCenterX = mediaQuery.size.width / 2;
      final screenCenterY = mediaQuery.size.height / 2;

      // Calculate offset from screen center
      final offsetX = childCenterX - screenCenterX;
      final offsetY = childCenterY - screenCenterY;

      return Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Center(
          child: AnimatedHandGesture(
            gesture: widget.gesture,
            iconColor: widget.iconColor,
            iconSize: widget.iconSize,
            customIcon: widget.customIcon,
          ),
        ),
      );
    } catch (e) {
      // Fallback to center if anything fails
      return Center(
        child: AnimatedHandGesture(
          gesture: widget.gesture,
          iconColor: widget.iconColor,
          iconSize: widget.iconSize,
          customIcon: widget.customIcon,
        ),
      );
    }
  }

  /// Builds the message box with professional styling and elevation.
  Widget _buildMessageBox() {
    return Align(
      alignment: widget.messageAlignment,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: widget.message,
      ),
    );
  }
}
