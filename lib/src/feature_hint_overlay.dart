import 'package:flutter/material.dart';
import 'dart:async';
import 'animated_hand_gesture.dart';
import 'models/gesture_type.dart';
import 'animation_state_manager.dart';

/// A widget that overlays your UI with an animated hint tutorial.
///
/// Automatically plays the animation for a specified duration and then closes.
/// Perfect for first-time user experiences and feature discovery.
///
/// Use the [uniqueKey] parameter to identify this widget instance, and set
/// [playOnceInLifetime] to true to ensure the animation plays only once.
///
/// By default, the overlay extends full-screen. Use [limitToChildBounds] to
/// constrain the overlay and animation within the bounds of the wrapped widget.
///
/// Example:
/// ```dart
/// // Full-screen overlay with message
/// FeatureHintOverlay(
///   uniqueKey: 'swipe_left_hint',
///   playOnceInLifetime: true,
///   message: Text('Swipe left to delete'),
///   gesture: GestureType.swipeLeft,
///   duration: Duration(seconds: 5),
///   child: YourWidget(),
/// )
///
/// // Overlay constrained to widget bounds
/// FeatureHintOverlay(
///   uniqueKey: 'tap_hint',
///   limitToChildBounds: true, // Constrains overlay to child widget bounds
///   gesture: GestureType.tap,
///   duration: Duration(seconds: 3),
///   child: YourWidget(),
/// )
/// ```
class FeatureHintOverlay extends StatefulWidget {
  /// The widget to overlay with the hint
  final Widget child;

  /// Message widget to display to the user.
  /// If not provided or null, no message will be rendered.
  final Widget? message;

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

  /// Optional custom widget to display instead of auto-detected gesture icon.
  ///
  /// If provided, the custom widget should include its own styling, size, and color.
  /// The widget will be constrained to a maximum of 120x120 pixels and will be
  /// automatically clipped to prevent overflow.
  ///
  /// The positioning will be smart enough to:
  /// - Stay within screen bounds
  /// - Avoid going off-screen
  /// - Prevent overflow and layout issues
  ///
  /// Examples:
  /// ```dart
  /// // Simple icon
  /// customIcon: Icon(Icons.favorite, size: 80, color: Colors.red)
  ///
  /// // Icon with badge
  /// customIcon: Badge(
  ///   label: Text('2'),
  ///   child: Icon(Icons.notifications, size: 70),
  /// )
  ///
  /// // Custom widget with animation
  /// customIcon: SizedBox(
  ///   width: 60,
  ///   height: 60,
  ///   child: YourCustomWidget(),
  /// )
  /// ```
  ///
  /// If not provided, an icon will be automatically selected based on [gesture].
  final Widget? customIcon;

  /// Unique identifier for this hint overlay.
  ///
  /// Used to track animation state when [playOnceInLifetime] is true.
  /// This is required to enable the [playOnceInLifetime] feature.
  final String uniqueKey;

  /// Whether to play the animation only once in the widget's lifetime.
  ///
  /// When true, the animation will play only once, even if the widget
  /// is rebuilt. State is tracked using the [uniqueKey].
  ///
  /// When false (default), the animation plays every time the widget is
  /// rebuilt and [shouldPlay] is true.
  final bool playOnceInLifetime;

  /// Whether to limit the overlay and animation within the bounds of the wrapped widget.
  ///
  /// When true, the overlay background, message, and gesture animation will be
  /// clipped to the bounds of the [child] widget. This prevents the overlay from
  /// extending beyond the wrapped widget's area.
  ///
  /// When false (default), the overlay extends full-screen with only the gesture
  /// animation being smart-positioned relative to the wrapped widget.
  ///
  /// This is useful when you want to highlight a specific widget without
  /// dimming the rest of the screen.
  final bool limitToChildBounds;

  const FeatureHintOverlay({
    Key? key,
    required this.child,
    this.message,
    required this.gesture,
    required this.uniqueKey,
    this.duration = const Duration(seconds: 4),
    this.shouldPlay = true,
    this.onCompleted,
    this.showHandAnimation = true,
    this.overlayColor = const Color(0xBF000000),
    this.messageAlignment = Alignment.topCenter,
    this.customIcon,
    this.playOnceInLifetime = false,
    this.limitToChildBounds = false,
  }) : assert(duration > Duration.zero, 'Duration must be positive'),
       super(key: key);

  @override
  State<FeatureHintOverlay> createState() => _FeatureHintOverlayState();
}

class _FeatureHintOverlayState extends State<FeatureHintOverlay>
    with SingleTickerProviderStateMixin {
  late bool _showOverlay = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final GlobalKey _childKey = GlobalKey();

  // Track if the state checking is in progress
  bool _stateCheckInProgress = false;

  // Track if dispose has been called
  bool _isDisposed = false;

  // Retry logic for transient failures
  int _retryCount = 0;
  static const int _maxRetries = 3;

  // Track scheduled dismiss timer to cancel it on dispose (prevents memory leaks)
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _initializeOverlay();
  }

  /// Initializes the overlay display and animation.
  void _initializeOverlay() {
    // Initialize fade animation controller first (synchronously)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Check animation state asynchronously
    _checkAnimationStateAndStart();
  }

  /// Checks if animation should play asynchronously and starts if needed.
  /// Includes error handling and retry logic.
  Future<void> _checkAnimationStateAndStart() async {
    if (_stateCheckInProgress || _isDisposed) return;

    _stateCheckInProgress = true;

    try {
      final canPlay = await _canPlayAnimation();

      if (_isDisposed) return;

      setState(() {
        _showOverlay = widget.shouldPlay && canPlay;
      });

      if (_showOverlay && mounted) {
        // Wait for first frame to be laid out before showing overlay
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isDisposed && mounted) {
            _fadeController.forward();
            _scheduleOverlayDismiss();
          }
        });
      }

      _retryCount = 0; // Reset retry count on success
    } catch (e) {
      // Handle transient failures with retry
      if (_retryCount < _maxRetries && !_isDisposed) {
        _retryCount++;
        await Future.delayed(Duration(milliseconds: 100 * _retryCount));
        _stateCheckInProgress = false;
        await _checkAnimationStateAndStart();
      } else {
        // After max retries, default to showing animation (safe fallback)
        if (!_isDisposed && mounted) {
          setState(() {
            _showOverlay = widget.shouldPlay;
          });
        }
      }
    } finally {
      _stateCheckInProgress = false;
    }
  }

  /// Checks if the animation can play based on [playOnceInLifetime] settings.
  ///
  /// Returns true if:
  /// - playOnceInLifetime is false, OR
  /// - The animation hasn't been played yet for this uniqueKey
  Future<bool> _canPlayAnimation() async {
    if (!widget.playOnceInLifetime) {
      return true;
    }

    try {
      return !(await AnimationStateManager.hasAnimationPlayed(
        widget.uniqueKey,
      ));
    } catch (e) {
      // If state check fails, default to showing animation (safe fallback)
      return true;
    }
  }

  /// Schedules the overlay to automatically close after [duration].
  void _scheduleOverlayDismiss() {
    _dismissTimer = Timer(widget.duration, () {
      if (!_isDisposed && mounted) {
        _dismissOverlay();
      }
    });
  }

  /// Dismisses the overlay with a fade-out animation.
  /// Includes error handling for state persistence.
  Future<void> _dismissOverlay() async {
    if (_isDisposed) return;

    try {
      await _fadeController.reverse();
    } catch (e) {
      // If animation fails, continue with state persistence
    }

    if (_isDisposed) return;

    if (mounted) {
      setState(() {
        _showOverlay = false;
      });

      // Mark animation as played if playOnceInLifetime is enabled
      if (widget.playOnceInLifetime) {
        try {
          await AnimationStateManager.markAnimationAsPlayed(widget.uniqueKey);
        } catch (e) {
          // If state persistence fails, animation is still tracked in memory
          // This is a graceful fallback - the widget still works
        }
      }

      widget.onCompleted?.call();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;

    // Cancel any scheduled dismiss timer (prevents memory leaks)
    _dismissTimer?.cancel();
    _dismissTimer = null;

    try {
      _fadeController.dispose();
    } catch (e) {
      // If animation controller disposal fails, continue
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The actual widget - always interactive and responsive, tracked for overlay positioning
        KeyedSubtree(key: _childKey, child: widget.child),

        // Overlay - positioned differently based on limitToChildBounds setting
        if (_showOverlay) _buildOverlayLayer(),
      ],
    );
  }

  /// Builds the overlay layer, respecting bounds constraints if enabled.
  Widget _buildOverlayLayer() {
    if (widget.limitToChildBounds) {
      // Bounded overlay: only covers the child widget area
      return _buildBoundedOverlay();
    } else {
      // Full-screen overlay: original behavior
      return Positioned.fill(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildFullScreenOverlay(),
        ),
      );
    }
  }

  /// Builds an overlay constrained to the child widget's bounds.
  Widget _buildBoundedOverlay() {
    final childRenderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;

    if (childRenderBox == null || !childRenderBox.hasSize) {
      // Fallback to full-screen if child size is unknown
      return Positioned.fill(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildFullScreenOverlay(),
        ),
      );
    }

    final childSize = childRenderBox.size;

    return Positioned(
      left: 0,
      top: 0,
      width: childSize.width,
      height: childSize.height,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Semi-transparent background covering only child area
            Container(color: widget.overlayColor),

            // Message box positioned according to messageAlignment (only if provided)
            if (widget.message != null) _buildMessageBox(),

            // Animated gesture icon positioned exactly over wrapped widget
            if (widget.showHandAnimation) _buildAnimatedGestureWithTransform(),
          ],
        ),
      ),
    );
  }

  /// Builds a full-screen overlay with semi-transparent background and positioned hint.
  Widget _buildFullScreenOverlay() {
    return Stack(
      children: [
        // Semi-transparent background covering entire screen
        Container(color: widget.overlayColor),

        // Message box positioned according to messageAlignment (only if provided)
        if (widget.message != null) _buildMessageBox(),

        // Animated gesture icon positioned exactly over wrapped widget
        if (widget.showHandAnimation) _buildAnimatedGestureWithTransform(),
      ],
    );
  }

  /// Builds the animated gesture icon using Transform to position it over the wrapped widget.
  /// Includes overflow protection and smart bounds checking.
  Widget _buildAnimatedGestureWithTransform() {
    // Get child render box
    final childRenderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;

    if (childRenderBox == null || !childRenderBox.hasSize) {
      // Show icon in center as fallback
      return Center(
        child: AnimatedHandGesture(
          gesture: widget.gesture,
          customIcon: widget.customIcon,
        ),
      );
    }

    try {
      // Get child position and size
      final childPosition = childRenderBox.localToGlobal(Offset.zero);
      final childSize = childRenderBox.size;
      final mediaQuery = MediaQuery.of(_childKey.currentContext!);

      // Icon bounds (120x120 with padding)
      const iconSize = 120.0;
      const padding = 20.0;
      final maxOffset = (iconSize / 2) + padding;

      if (widget.limitToChildBounds) {
        // When limited to child bounds, position relative to child widget center
        // The Positioned widget already constrains to child bounds, so just center
        return Center(
          child: AnimatedHandGesture(
            gesture: widget.gesture,
            customIcon: widget.customIcon,
          ),
        );
      } else {
        // Original behavior: position relative to screen center
        // Calculate center position of the child widget
        final childCenterX = childPosition.dx + (childSize.width / 2);
        final childCenterY = childPosition.dy + (childSize.height / 2);

        // Center of screen
        final screenCenterX = mediaQuery.size.width / 2;
        final screenCenterY = mediaQuery.size.height / 2;

        // Calculate offset from screen center
        var offsetX = childCenterX - screenCenterX;
        var offsetY = childCenterY - screenCenterY;

        // Clamp offset to prevent the icon from going too far off-center
        // This prevents overflow and keeps the icon visible
        offsetX = offsetX.clamp(-maxOffset, maxOffset);
        offsetY = offsetY.clamp(-maxOffset, maxOffset);

        // Additional check: ensure icon stays within screen bounds
        final iconLeft = screenCenterX + offsetX - (iconSize / 2);
        final iconTop = screenCenterY + offsetY - (iconSize / 2);
        final iconRight = iconLeft + iconSize;
        final iconBottom = iconTop + iconSize;

        // If icon would go off-screen, adjust position to keep it visible
        if (iconLeft < padding) {
          offsetX = offsetX + (padding - iconLeft);
        }
        if (iconRight > mediaQuery.size.width - padding) {
          offsetX = offsetX - (iconRight - (mediaQuery.size.width - padding));
        }
        if (iconTop < padding) {
          offsetY = offsetY + (padding - iconTop);
        }
        if (iconBottom > mediaQuery.size.height - padding) {
          offsetY = offsetY - (iconBottom - (mediaQuery.size.height - padding));
        }

        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Center(
            child: AnimatedHandGesture(
              gesture: widget.gesture,
              customIcon: widget.customIcon,
            ),
          ),
        );
      }
    } catch (e) {
      // Fallback to center if anything fails
      return Center(
        child: AnimatedHandGesture(
          gesture: widget.gesture,
          customIcon: widget.customIcon,
        ),
      );
    }
  }

  /// Builds the message box with professional styling and elevation.
  /// Only called if message is provided.
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
