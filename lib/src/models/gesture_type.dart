/// Supported gesture types for feature hints
enum GestureType {
  /// Horizontal swipe from right to left
  swipeLeft,

  /// Horizontal swipe from left to right
  swipeRight,

  /// Vertical swipe from bottom to top
  swipeUp,

  /// Vertical swipe from top to bottom
  swipeDown,

  /// Single tap gesture
  tap,

  /// Long press gesture
  longPress,
}

/// Extension to get gesture details
extension GestureTypeExtension on GestureType {
  /// Human-readable name for the gesture
  String get displayName {
    switch (this) {
      case GestureType.swipeLeft:
        return 'Swipe Left';
      case GestureType.swipeRight:
        return 'Swipe Right';
      case GestureType.swipeUp:
        return 'Swipe Up';
      case GestureType.swipeDown:
        return 'Swipe Down';
      case GestureType.tap:
        return 'Tap';
      case GestureType.longPress:
        return 'Long Press';
    }
  }
}
