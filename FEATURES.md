# Flutter Feature Hint - Complete Features Guide

## 📋 Table of Contents
1. [Core Features](#core-features)
2. [New Features in v0.2.0](#new-features-in-v020-)
3. [Customization Options](#customization-options)
4. [Advanced Usage](#advanced-usage)
5. [API Reference](#api-reference)

---

## 🎯 Core Features

### 1. Full-Screen Overlay System
Display a semi-transparent overlay covering the entire screen, dimming the background while highlighting your target widget.

```dart
FeatureHintOverlay(
  uniqueKey: 'full_screen_hint',
  gesture: GestureType.tap,
  message: const Text('This is a full-screen overlay'),
  child: YourWidget(),
)
```

**Benefits:**
- Captures user attention effectively
- Perfect for onboarding flows
- Works across all screen sizes
- Customizable overlay color and opacity

---

### 2. Auto-Playing Animations
No user interaction needed - animations play automatically when the widget is built.

```dart
FeatureHintOverlay(
  uniqueKey: 'auto_play',
  gesture: GestureType.swipeLeft,
  duration: const Duration(seconds: 5),
  shouldPlay: true, // Auto-play (default)
  child: YourWidget(),
)
```

**Features:**
- Automatic fade-in (300ms smooth transition)
- Customizable duration
- Gesture animation synchronized with overlay fade
- Automatic fade-out and cleanup

---

### 3. Six Gesture Types
Demonstrate various gestures with unique animations:

| Gesture | Animation | Use Case |
|---------|-----------|----------|
| **Swipe Left** | Moves from right to left | Delete, archive actions |
| **Swipe Right** | Moves from left to right | Navigation, undo actions |
| **Swipe Up** | Moves from bottom to top | Reveal, scroll up hints |
| **Swipe Down** | Moves from top to bottom | Pull-to-refresh, collapse |
| **Tap** | Bouncing motion | Button clicks, selections |
| **Long Press** | Sustained press animation | Context menus, hold actions |

```dart
// Example: Show different gestures
FeatureHintOverlay(
  uniqueKey: 'swipe_demo',
  gesture: GestureType.swipeRight, // Choose your gesture
  child: YourWidget(),
)
```

---

### 4. Smooth Fade Animations
Professional 300ms fade transitions for overlay visibility.

```dart
FeatureHintOverlay(
  uniqueKey: 'fade_animation',
  duration: const Duration(seconds: 4),
  // Fade-in on show (300ms)
  // Fade-out after duration
  child: YourWidget(),
)
```

**Animation Details:**
- Fade-in: 300ms with easeInOut curve
- Duration: Fully visible for specified time
- Fade-out: 300ms with easeInOut curve
- Smooth, professional appearance

---

### 5. Responsive Design
Works with widgets of any size and layout complexity.

```dart
// Works with tiny buttons
FeatureHintOverlay(
  uniqueKey: 'tiny_button',
  gesture: GestureType.tap,
  child: SizedBox(width: 40, height: 40, child: ElevatedButton(...)),
)

// Works with full-screen lists
FeatureHintOverlay(
  uniqueKey: 'full_list',
  gesture: GestureType.swipeLeft,
  child: ListView(children: [...]),
)

// Works with complex nested widgets
FeatureHintOverlay(
  uniqueKey: 'complex_card',
  gesture: GestureType.tap,
  child: Card(child: Column(children: [...])),
)
```

---

### 6. Precise Positioning
Automatically calculates and positions the gesture animation icon over your wrapped widget.

```dart
FeatureHintOverlay(
  uniqueKey: 'precise_pos',
  gesture: GestureType.tap,
  // Animation icon automatically positioned:
  // - Center of wrapped widget
  // - Within screen bounds
  // - With 20px padding from edges
  child: YourWidget(),
)
```

**Smart Positioning Features:**
- Calculates widget center automatically
- Prevents off-screen rendering
- Adaptive positioning based on widget location
- Smooth offset calculations

---

### 7. Zero Dependencies
Uses only Flutter's built-in widgets and `shared_preferences` (for state persistence).

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.0  # Only external dependency (optional for state)
```

**No dependencies on:**
- Animation packages
- State management libraries
- Custom painters
- Platform channels

---

## 🆕 New Features in v0.2.0+

### ⭐ 1. Bounded Overlay (limitToChildBounds)

Constrain the entire overlay (background, message, and animation) to the bounds of the wrapped widget.

```dart
FeatureHintOverlay(
  uniqueKey: 'bounded_hint',
  limitToChildBounds: true, // ⭐ NEW!
  gesture: GestureType.tap,
  message: const Text('Focused hint'),
  child: YourWidget(),
)
```

**Features:**
- ✅ Overlay clips to child widget bounds
- ✅ No full-screen dimming
- ✅ Message stays within bounds
- ✅ Animation constrained to widget area
- ✅ Perfect for highlighting specific UI sections

**Use Cases:**
```dart
// Highlight a button without dimming entire screen
FeatureHintOverlay(
  uniqueKey: 'save_button',
  limitToChildBounds: true,
  gesture: GestureType.tap,
  message: const Text('Click to save'),
  child: SaveButton(),
)

// Focus on a form section
FeatureHintOverlay(
  uniqueKey: 'email_field',
  limitToChildBounds: true,
  gesture: GestureType.tap,
  message: const Text('Enter your email'),
  child: EmailFormField(),
)

// Highlight a card in a list
FeatureHintOverlay(
  uniqueKey: 'card_highlight',
  limitToChildBounds: true,
  gesture: GestureType.swipeLeft,
  message: const Text('Swipe to see more'),
  child: FeatureCard(),
)
```

---

### ⭐ 2. Required uniqueKey

Every overlay must have a unique identifier for proper state tracking.

```dart
FeatureHintOverlay(
  uniqueKey: 'my_unique_hint_id', // ⭐ REQUIRED
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

**Why Required?**
- ✅ Enables `playOnceInLifetime` feature
- ✅ Prevents duplicate animation tracking
- ✅ Allows resetting animations programmatically
- ✅ Better error detection

**Best Practices:**
```dart
// Use descriptive, hierarchical keys
'onboarding_step_1_swipe_hint'
'list_item_delete_hint'
'form_email_field_hint'
'profile_edit_button_hint'
```

---

### ⭐ 3. Optional Message Parameter

Message is now optional! Show just the animation if you prefer.

```dart
// With message (traditional)
FeatureHintOverlay(
  uniqueKey: 'with_message',
  message: const Text('Do this!'),
  gesture: GestureType.tap,
  child: YourWidget(),
)

// Without message (new!)
FeatureHintOverlay(
  uniqueKey: 'animation_only',
  // No message parameter
  gesture: GestureType.swipeLeft,
  child: YourWidget(),
)
```

**When to Use:**
- Minimal UI design
- Animation speaks for itself
- Space constraints
- Simplicity preferred

---

### ⭐ 4. Widget-Based Custom Icons

`customIcon` now accepts any Widget, not just IconData!

```dart
// Before (v0.0.2) - IconData only:
// customIcon: Icons.favorite

// After (v0.2.0) - Any Widget!

// Simple Icon widget
customIcon: Icon(
  Icons.favorite,
  size: 48,
  color: Colors.red,
)

// Icon with animation
customIcon: const Pulse(
  child: Icon(Icons.notification, size: 48),
)

// Complex custom widget
customIcon: Badge(
  label: const Text('2'),
  child: const Icon(Icons.message, size: 48),
)

// Custom painted widget
customIcon: CustomPaint(
  painter: MyCustomPainter(),
  size: const Size(48, 48),
)
```

**Advantages:**
- ✅ More flexibility
- ✅ Can include badges, animations, etc.
- ✅ Matches your design system
- ✅ Reusable custom components

---

### ⭐ 5. Auto Icon Detection

Icons are automatically selected based on gesture type if no custom icon provided.

```dart
// No customIcon provided
FeatureHintOverlay(
  uniqueKey: 'auto_icon',
  gesture: GestureType.swipeLeft,
  // Automatically uses Icons.swipe
  child: YourWidget(),
)

// Gesture to Icon Mapping:
// - swipeLeft/Right/Up/Down → Icons.swipe
// - tap → Icons.touch_app
// - longPress → Icons.touch_app
```

---

### ⭐ 6. Memory Leak Fixes

**Problem Solved:**
- ✅ Timer now properly cancelled on dispose
- ✅ No more untracked Future.delayed
- ✅ All resources cleaned up correctly

```dart
@override
void dispose() {
  _isDisposed = true;
  _dismissTimer?.cancel(); // ⭐ Prevents memory leaks
  _fadeController.dispose();
  super.dispose();
}
```

---

## 🎨 Customization Options

### 1. Message Styling

```dart
FeatureHintOverlay(
  uniqueKey: 'styled_message',
  gesture: GestureType.tap,
  message: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.info_outline, color: Colors.white),
        const SizedBox(height: 8),
        const Text(
          'Custom styled message',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  ),
  child: YourWidget(),
)
```

### 2. Overlay Color & Opacity

```dart
FeatureHintOverlay(
  uniqueKey: 'colored_overlay',
  overlayColor: Colors.blue.withOpacity(0.5), // Custom color
  gesture: GestureType.tap,
  child: YourWidget(),
)

// Default: Color(0xBF000000) - semi-transparent black (75% opacity)
```

### 3. Message Alignment

```dart
FeatureHintOverlay(
  uniqueKey: 'top_message',
  messageAlignment: Alignment.topCenter, // Top (default)
  gesture: GestureType.tap,
  child: YourWidget(),
)

FeatureHintOverlay(
  uniqueKey: 'bottom_message',
  messageAlignment: Alignment.bottomCenter, // Bottom
  gesture: GestureType.tap,
  child: YourWidget(),
)

FeatureHintOverlay(
  uniqueKey: 'center_message',
  messageAlignment: Alignment.center, // Center
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

### 4. Animation Duration

```dart
FeatureHintOverlay(
  uniqueKey: 'quick_hint',
  duration: const Duration(seconds: 2), // Quick
  gesture: GestureType.tap,
  child: YourWidget(),
)

FeatureHintOverlay(
  uniqueKey: 'long_hint',
  duration: const Duration(seconds: 10), // Longer
  gesture: GestureType.tap,
  child: YourWidget(),
)

// Default: 4 seconds
```

### 5. Show/Hide Control

```dart
bool shouldShowHint = true;

FeatureHintOverlay(
  uniqueKey: 'conditional_hint',
  shouldPlay: shouldShowHint, // Control visibility
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

### 6. Gesture Animation Toggle

```dart
FeatureHintOverlay(
  uniqueKey: 'no_gesture',
  showHandAnimation: false, // Hide gesture animation, show message only
  message: const Text('Just the message'),
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

---

## 🚀 Advanced Usage

### 1. Play Once in Lifetime

Show animation only once per unique key, even after app restart.

```dart
FeatureHintOverlay(
  uniqueKey: 'welcome_hint',
  playOnceInLifetime: true, // Play only once
  gesture: GestureType.tap,
  message: const Text('Welcome!'),
  child: YourWidget(),
)

// The animation will play the first time,
// and never again, even after closing and reopening the app.
```

### 2. Completion Callback

Execute code when animation finishes.

```dart
FeatureHintOverlay(
  uniqueKey: 'callback_hint',
  gesture: GestureType.tap,
  onCompleted: () {
    // Animation finished!
    print('Hint animation completed');
    analytics.logEvent('hint_viewed');
  },
  child: YourWidget(),
)
```

### 3. Reset Animations Programmatically

```dart
import 'package:flutter_feature_hint/flutter_feature_hint.dart';

// Reset single animation
await AnimationStateManager.resetAnimation('welcome_hint');

// Reset all animations
await AnimationStateManager.resetAllAnimations();

// Check if animation was played
bool hasPlayed = await AnimationStateManager.hasAnimationPlayed('welcome_hint');
```

### 4. Multiple Hints in Sequence

```dart
int step = 0;

Column(
  children: [
    FeatureHintOverlay(
      uniqueKey: 'step_1',
      shouldPlay: step == 0,
      gesture: GestureType.tap,
      message: const Text('Step 1: Click here'),
      onCompleted: () => setState(() => step = 1),
      child: FirstWidget(),
    ),
    FeatureHintOverlay(
      uniqueKey: 'step_2',
      shouldPlay: step == 1,
      gesture: GestureType.swipeLeft,
      message: const Text('Step 2: Swipe here'),
      onCompleted: () => setState(() => step = 2),
      child: SecondWidget(),
    ),
  ],
)
```

### 5. Conditional Overlays Based on State

```dart
bool isFirstTime = await checkIfFirstTime();

FeatureHintOverlay(
  uniqueKey: 'onboarding_hint',
  shouldPlay: isFirstTime,
  playOnceInLifetime: true,
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

---

## 📚 API Reference

### FeatureHintOverlay Constructor

```dart
const FeatureHintOverlay({
  Key? key,
  
  // REQUIRED
  required Widget child,
  required GestureType gesture,
  required String uniqueKey,
  
  // OPTIONAL - Content
  Widget? message,
  Widget? customIcon,
  
  // OPTIONAL - Timing
  Duration duration = const Duration(seconds: 4),
  
  // OPTIONAL - Behavior
  bool shouldPlay = true,
  bool playOnceInLifetime = false,
  bool limitToChildBounds = false,
  bool showHandAnimation = true,
  
  // OPTIONAL - Styling
  Color overlayColor = const Color(0xBF000000),
  AlignmentGeometry messageAlignment = Alignment.topCenter,
  
  // OPTIONAL - Callbacks
  VoidCallback? onCompleted,
})
```

### GestureType Enum

```dart
enum GestureType {
  swipeLeft,
  swipeRight,
  swipeUp,
  swipeDown,
  tap,
  longPress,
}
```

### AnimationStateManager Methods

```dart
// Check if animation was played
static Future<bool> hasAnimationPlayed(String uniqueKey)

// Mark animation as played
static Future<void> markAnimationAsPlayed(String uniqueKey)

// Reset single animation
static Future<void> resetAnimation(String uniqueKey)

// Reset all animations
static Future<void> resetAllAnimations()

// Enable debug logging
static void setDebugLogging(bool enabled)
```

---

## ✅ Production Checklist

- ✅ Zero compilation errors
- ✅ Memory leak fixes (Timer cancellation)
- ✅ Thread-safe state management
- ✅ Graceful error handling
- ✅ Edge case coverage
- ✅ Comprehensive documentation
- ✅ Example app included
- ✅ Persistent state across restarts

---

**Ready to use in production!** 🚀
