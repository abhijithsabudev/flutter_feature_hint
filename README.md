# flutter_feature_hint

Create interactive feature tutorials with gesture-driven overlays. Users must perform actual gestures on your UI to dismiss hints - perfect for onboarding and feature discovery.

## Features

- 🎯 **Interactive Overlays**: Users learn by doing, not just reading
- 👆 **Multiple Gesture Types**: Swipe, tap, long press support
- ✨ **Animated Hand Gestures**: Visual guidance shows exactly what to do
- 🎨 **Customizable**: Control colors, text styles, positioning
- 🎪 **Spotlight Effect**: Highlight specific widgets
- 📱 **Haptic Feedback**: Confirms successful gestures

## Demo

![Demo GIF](https://your-demo-url.com/demo.gif)

## Installation

Add this to your `pubspec.yaml`:
```yaml
dependencies:
  flutter_feature_hint: ^0.0.1
```

Then run:
```bash
flutter pub get
```

## Usage

### Basic Example
```dart
import 'package:flutter_feature_hint/flutter_feature_hint.dart';

FeatureHintOverlay(
  message: "Swipe left to delete",
  gesture: GestureType.swipeLeft,
  onGestureCompleted: () {
    print("User learned the gesture!");
  },
  child: YourWidget(),
)
```

### With Spotlight Effect
```dart
final GlobalKey buttonKey = GlobalKey();

FeatureHintOverlay(
  message: "Tap this button to continue",
  gesture: GestureType.tap,
  targetKey: buttonKey,
  onGestureCompleted: () {
    // User tapped the highlighted button
  },
  child: Column(
    children: [
      ElevatedButton(
        key: buttonKey,
        onPressed: () {},
        child: Text('Continue'),
      ),
    ],
  ),
)
```

### Sequential Hints
```dart
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _currentHint = 0;

  @override
  Widget build(BuildContext context) {
    Widget content = YourActualWidget();

    if (_currentHint == 0) {
      content = FeatureHintOverlay(
        message: "First, swipe left",
        gesture: GestureType.swipeLeft,
        onGestureCompleted: () {
          setState(() => _currentHint = 1);
        },
        child: content,
      );
    } else if (_currentHint == 1) {
      content = FeatureHintOverlay(
        message: "Now tap here",
        gesture: GestureType.tap,
        onGestureCompleted: () {
          setState(() => _currentHint = 2);
        },
        child: content,
      );
    }

    return content;
  }
}
```

## Supported Gestures

- `GestureType.swipeLeft` - Swipe from right to left
- `GestureType.swipeRight` - Swipe from left to right
- `GestureType.swipeUp` - Swipe from bottom to top
- `GestureType.swipeDown` - Swipe from top to bottom
- `GestureType.tap` - Single tap
- `GestureType.longPress` - Long press and hold

## Customization
```dart
FeatureHintOverlay(
  message: "Your message",
  gesture: GestureType.swipeLeft,
  onGestureCompleted: () {},
  
  // Customization options
  overlayColor: Colors.black.withOpacity(0.8),
  messageStyle: TextStyle(fontSize: 20, color: Colors.white),
  messageAlignment: Alignment.bottomCenter,
  showHandAnimation: false,
  swipeVelocityThreshold: 700.0,
  spotlightPadding: EdgeInsets.all(16),
  
  child: YourWidget(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `message` | `String` | required | Text to display to user |
| `gesture` | `GestureType` | required | Required gesture type |
| `child` | `Widget` | required | Widget to overlay |
| `onGestureCompleted` | `VoidCallback` | required | Called when gesture is performed |
| `showHandAnimation` | `bool` | `true` | Show animated hand |
| `showOverlay` | `bool` | `true` | Control overlay visibility |
| `overlayColor` | `Color` | `Color(0xBF000000)` | Overlay background color |
| `messageStyle` | `TextStyle?` | `null` | Custom text style |
| `messageAlignment` | `AlignmentGeometry` | `Alignment.topCenter` | Message position |
| `swipeVelocityThreshold` | `double` | `500.0` | Minimum swipe speed |
| `targetKey` | `GlobalKey?` | `null` | Widget to spotlight |
| `spotlightPadding` | `EdgeInsets` | `EdgeInsets.all(8)` | Padding around spotlight |

## Contributing

Contributions are welcome! Please read our contributing guide and submit pull requests.

## License

MIT License - see LICENSE file for details