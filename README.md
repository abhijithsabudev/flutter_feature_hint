# flutter_feature_hint

A beautiful Flutter package for creating smooth, auto-playing feature hint overlays with animated gestures. Perfect for onboarding, feature discovery, and user education.

## ✨ Features

- 🎯 **Full-Screen Overlays**: Cover the entire screen while highlighting the target widget
- 🎬 **Auto-Playing Animations**: No user interaction required - animations play automatically
- ✨ **Animated Gestures**: Visual demonstrations of swipe, tap, and long-press actions
- 🎨 **Highly Customizable**: Control colors, duration, message widgets, icon sizes, and positioning
- 🚀 **Smooth Fade Animations**: Professional fade in/out transitions
- 📱 **Responsive Design**: Works with widgets of any size, from tiny buttons to entire lists
- 🎯 **Precise Positioning**: Animation icon automatically positions over the wrapped widget
- 🔧 **Zero Dependencies**: Uses only Flutter's built-in widgets and animations

## 📸 Demo

The example app demonstrates a beautiful task manager UI with:
- Dismissible list items with swipe animations
- Modern gradient design with Material 3
- Feature hint overlay showing swipe gestures
- Smooth transitions and feedback

### Gesture Demonstrations

<table>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/abhijithsabudev/flutter_feature_hint/main/docs/gifs/swipe_left.gif" width="200" alt="Swipe Left"/>
      <br><b>Swipe Left</b>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/abhijithsabudev/flutter_feature_hint/main/docs/gifs/swipe_right.gif" width="200" alt="Swipe Right"/>
      <br><b>Swipe Right</b>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/abhijithsabudev/flutter_feature_hint/main/docs/gifs/swipe_up.gif" width="200" alt="Swipe Up"/>
      <br><b>Swipe Up</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/abhijithsabudev/flutter_feature_hint/main/docs/gifs/swipe_down.gif" width="200" alt="Swipe Down"/>
      <br><b>Swipe Down</b>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/abhijithsabudev/flutter_feature_hint/main/docs/gifs/tap.gif" width="200" alt="Tap"/>
      <br><b>Tap</b>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/abhijithsabudev/flutter_feature_hint/main/docs/gifs/long_press.gif" width="200" alt="Long Press"/>
      <br><b>Long Press</b>
    </td>
  </tr>
</table>

## 🚀 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_feature_hint: ^0.0.2
```

Then run:

```bash
flutter pub get
```

## 📖 Usage

### Basic Example

```dart
import 'package:flutter_feature_hint/flutter_feature_hint.dart';

FeatureHintOverlay(
  message: const Text('Swipe left to delete'),
  gesture: GestureType.swipeLeft,
  duration: const Duration(seconds: 5),
  child: YourWidget(),
)
```

### With Custom Styling

```dart
FeatureHintOverlay(
  message: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.indigo[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.touch_app,
            size: 18,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Try swiping items!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Swipe left to delete or right to complete",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  ),
  gesture: GestureType.swipeLeft,
  duration: const Duration(seconds: 6),
  iconSize: 48,
  iconColor: Colors.white,
  overlayColor: const Color(0xBF000000),
  child: YourListView(),
)
```

### Available Gesture Types

```dart
enum GestureType {
  swipeLeft,      // Horizontal swipe to the left
  swipeRight,     // Horizontal swipe to the right
  swipeUp,        // Vertical swipe upward
  swipeDown,      // Vertical swipe downward
  tap,            // Single tap gesture
  longPress,      // Long press gesture
}
```

### Parameters

- **`message`** (Widget, required): Custom widget to display as the hint message
- **`gesture`** (GestureType, required): The gesture type to animate
- **`child`** (Widget, required): The widget to wrap with the overlay
- **`duration`** (Duration, default: 4 seconds): How long to show the overlay
- **`shouldPlay`** (bool, default: true): Whether to show the overlay
- **`onCompleted`** (VoidCallback?): Callback when the overlay animation completes
- **`showHandAnimation`** (bool, default: true): Whether to show the gesture animation
- **`overlayColor`** (Color, default: semi-transparent black): Background color of the overlay
- **`messageAlignment`** (AlignmentGeometry, default: topCenter): Position of the message box
- **`customIcon`** (IconData?): Custom icon to animate instead of the hand gesture
- **`iconSize`** (double, default: 60.0): Size of the animated icon
- **`iconColor`** (Color, default: white): Color of the animated icon

### With Callback

```dart
FeatureHintOverlay(
  message: const Text('Learn this gesture!'),
  gesture: GestureType.tap,
  child: YourWidget(),
  onCompleted: () {
    print('Hint animation completed!');
    // Update UI state, navigate, etc.
  },
)
```

### Conditional Display

```dart
FeatureHintOverlay(
  message: const Text('First time? Swipe left!'),
  gesture: GestureType.swipeLeft,
  shouldPlay: isFirstTime, // Only show on first visit
  child: YourListView(),
)
```

## 🎨 Customization Guide

### Change Message Position

```dart
FeatureHintOverlay(
  messageAlignment: Alignment.bottomCenter, // Top, bottom, center, etc.
  // ... other parameters
)
```

### Use Custom Icon

```dart
FeatureHintOverlay(
  customIcon: Icons.favorite,
  iconColor: Colors.red,
  iconSize: 80,
  // ... other parameters
)
```

### Customize Overlay Appearance

```dart
FeatureHintOverlay(
  overlayColor: const Color(0xAA000000), // Semi-transparent dark
  messageAlignment: Alignment.center,
  // ... other parameters
)
```

## 🏗️ Architecture

The package is built with:

- **FeatureHintOverlay**: Main widget that wraps your UI with the overlay
- **AnimatedHandGesture**: Handles gesture-specific animations (swipes, taps, etc.)
- **GestureType**: Enum defining supported gesture animations

### How It Works

1. **Initialization**: When `FeatureHintOverlay` is rendered, it wraps your widget in a `Stack`
2. **Overlay Creation**: After the first frame is laid out, a full-screen overlay is displayed with a fade animation
3. **Animation**: The gesture animation icon is positioned exactly over your wrapped widget
4. **Auto-Dismiss**: After the specified duration, the overlay fades out automatically
5. **Callback**: The `onCompleted` callback is triggered when the animation finishes

## 🐛 Troubleshooting

### Animation Not Visible

- Ensure `shouldPlay` is set to `true`
- Check that `showHandAnimation` is not `false`
- Verify the overlay duration is long enough to see the animation

### Icon Not Positioned Correctly

- Ensure the wrapped widget has been fully laid out (happens automatically)
- The icon should appear centered on your wrapped widget
- If the widget is off-screen, the icon will also be off-screen

### Message Box Not Showing

- Verify the `message` parameter is a valid Widget
- Check that `messageAlignment` is set to a visible position
- Ensure the overlay color is not completely opaque, blocking the message

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## 📚 Example App

Check out the `example/` directory for a complete working example with a beautiful task manager UI demonstrating:
- Multiple feature hints
- Custom message styling
- Integration with dismissible list items
- Modern Material 3 design

## 🎯 Use Cases

- **Onboarding**: Guide users through your app's features
- **Feature Discovery**: Highlight new features to existing users
- **Tutorial Mode**: Show gesture-based interactions visually
- **First-Time UX**: Educate users without interrupting their experience
- **A/B Testing**: Test different onboarding approaches

## 📊 Requirements

- Flutter: ^3.0.0
- Dart: ^2.17.0

## 🔄 Version History

See [CHANGELOG.md](CHANGELOG.md) for a list of all changes and new features.

---

Built with ❤️ for Flutter developers
