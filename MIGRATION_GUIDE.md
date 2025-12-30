# Migration Guide: v0.0.2 → v0.2.0

This guide helps you upgrade from `flutter_feature_hint v0.0.2` to `v0.2.0` with all the new features.

## 📋 What Changed

### Breaking Changes ⚠️

#### 1. `uniqueKey` is Now Required

**Before (v0.0.2):**
```dart
FeatureHintOverlay(
  message: const Text('Hint message'),
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

**After (v0.2.0):**
```dart
FeatureHintOverlay(
  uniqueKey: 'my_hint_id', // ⭐ REQUIRED
  message: const Text('Hint message'),
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

**Why?** Enables `playOnceInLifetime` feature and better state tracking.

**Migration:** Add a unique key to each `FeatureHintOverlay`:
```dart
// Good keys:
'onboarding_welcome'
'list_swipe_delete'
'button_tap_action'
'form_field_focus'
```

---

#### 2. `customIcon` Now Accepts Widget, Not IconData

**Before (v0.0.2):**
```dart
FeatureHintOverlay(
  customIcon: Icons.favorite, // IconData
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

**After (v0.2.0):**
```dart
FeatureHintOverlay(
  customIcon: Icon(
    Icons.favorite,
    size: 48,
    color: Colors.red,
  ), // Widget
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

**Why?** More flexibility - now supports badges, animations, custom widgets.

**Migration Guide:**

| Before | After |
|--------|-------|
| `customIcon: Icons.favorite` | `customIcon: Icon(Icons.favorite)` |
| `customIcon: Icons.swipe_right` | `customIcon: Icon(Icons.swipe_right)` |
| No icon size control | `customIcon: Icon(Icons.check, size: 48)` |
| No icon color control | `customIcon: Icon(Icons.check, color: Colors.green)` |

---

### Non-Breaking Enhancements ✨

#### 1. Message is Now Optional

```dart
// Still works (with message)
FeatureHintOverlay(
  uniqueKey: 'with_message',
  message: const Text('Do this!'),
  gesture: GestureType.tap,
  child: YourWidget(),
)

// ⭐ NEW: Without message (animation only)
FeatureHintOverlay(
  uniqueKey: 'animation_only',
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

**No action needed** - existing code continues to work.

---

#### 2. New: limitToChildBounds Parameter

```dart
// New feature (default is false)
FeatureHintOverlay(
  uniqueKey: 'bounded_hint',
  limitToChildBounds: true, // ⭐ NEW
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

**No action needed** - use if you want the new feature.

---

## 🔄 Step-by-Step Migration

### Step 1: Update pubspec.yaml

```yaml
dependencies:
  flutter_feature_hint: ^0.2.0  # Update version
```

Run `flutter pub get`.

---

### Step 2: Add uniqueKey to Each Overlay

Find all `FeatureHintOverlay` widgets and add a `uniqueKey`:

```dart
// Example 1: Swipe hint
FeatureHintOverlay(
  uniqueKey: 'list_item_swipe', // ⭐ ADD THIS
  message: const Text('Swipe to delete'),
  gesture: GestureType.swipeLeft,
  child: ListItem(),
)

// Example 2: Tap hint
FeatureHintOverlay(
  uniqueKey: 'button_tap_action', // ⭐ ADD THIS
  message: const Text('Click here'),
  gesture: GestureType.tap,
  child: MyButton(),
)
```

---

### Step 3: Update customIcon Usage

If using `customIcon`, change from IconData to Widget:

**Before:**
```dart
FeatureHintOverlay(
  customIcon: Icons.favorite,
  ...
)
```

**After:**
```dart
FeatureHintOverlay(
  customIcon: Icon(Icons.favorite),
  ...
)
```

Or with styling:
```dart
FeatureHintOverlay(
  customIcon: Icon(
    Icons.favorite,
    size: 48,
    color: Colors.red,
  ),
  ...
)
```

---

### Step 4: Optional - Use New Features

#### Try Bounded Overlays
```dart
FeatureHintOverlay(
  uniqueKey: 'card_highlight',
  limitToChildBounds: true, // ⭐ NEW: Limit to widget bounds
  gesture: GestureType.tap,
  message: const Text('Tap to expand'),
  child: MyCard(),
)
```

#### Try Optional Messages
```dart
FeatureHintOverlay(
  uniqueKey: 'animation_hint',
  // No message - just animation
  gesture: GestureType.swipeLeft,
  child: YourWidget(),
)
```

#### Try PlayOnceInLifetime
```dart
FeatureHintOverlay(
  uniqueKey: 'onboarding',
  playOnceInLifetime: true, // ⭐ Show only once!
  message: const Text('Welcome!'),
  gesture: GestureType.tap,
  child: WelcomeWidget(),
)
```

---

## 🔍 Common Migration Scenarios

### Scenario 1: Simple Message Overlay

**Before:**
```dart
FeatureHintOverlay(
  message: const Text('Tap to proceed'),
  gesture: GestureType.tap,
  duration: const Duration(seconds: 4),
  child: MyButton(),
)
```

**After:**
```dart
FeatureHintOverlay(
  uniqueKey: 'my_button_hint', // ✅ Add this
  message: const Text('Tap to proceed'),
  gesture: GestureType.tap,
  duration: const Duration(seconds: 4),
  child: MyButton(),
)
```

---

### Scenario 2: Custom Icon

**Before:**
```dart
FeatureHintOverlay(
  customIcon: Icons.favorite,
  gesture: GestureType.tap,
  child: LikeButton(),
)
```

**After:**
```dart
FeatureHintOverlay(
  uniqueKey: 'like_button', // ✅ Add this
  customIcon: Icon(Icons.favorite, color: Colors.red), // ✅ Change to Widget
  gesture: GestureType.tap,
  child: LikeButton(),
)
```

---

### Scenario 3: List Item Swipe

**Before:**
```dart
ListView.builder(
  itemBuilder: (context, index) {
    return FeatureHintOverlay(
      message: const Text('Swipe to delete'),
      gesture: GestureType.swipeLeft,
      child: ListItem(item: items[index]),
    );
  },
)
```

**After:**
```dart
ListView.builder(
  itemBuilder: (context, index) {
    return FeatureHintOverlay(
      uniqueKey: 'list_item_${items[index].id}', // ✅ Unique per item
      message: const Text('Swipe to delete'),
      gesture: GestureType.swipeLeft,
      child: ListItem(item: items[index]),
    );
  },
)
```

---

### Scenario 4: Onboarding Tutorial

**Before:**
```dart
FeatureHintOverlay(
  message: const Text('Step 1'),
  gesture: GestureType.tap,
  child: FirstFeature(),
)
```

**After (with playOnceInLifetime):**
```dart
FeatureHintOverlay(
  uniqueKey: 'onboarding_step_1', // ✅ Add
  message: const Text('Step 1'),
  gesture: GestureType.tap,
  playOnceInLifetime: true, // ✅ Show only once!
  child: FirstFeature(),
)
```

---

## 🚀 New Features to Explore

### 1. Bounded Overlays
Perfect for highlighting specific UI components:

```dart
FeatureHintOverlay(
  uniqueKey: 'card_hint',
  limitToChildBounds: true, // ⭐ Only covers the card
  gesture: GestureType.tap,
  message: const Text('Tap this card'),
  child: MyCard(),
)
```

### 2. Animation-Only Hints
Show gesture without message for cleaner UI:

```dart
FeatureHintOverlay(
  uniqueKey: 'gesture_hint',
  gesture: GestureType.swipeLeft,
  // No message - animation speaks for itself
  child: YourWidget(),
)
```

### 3. Reset Animations
Allow users to replay hints:

```dart
ElevatedButton(
  onPressed: () async {
    await AnimationStateManager.resetAnimation('onboarding');
  },
  child: const Text('Replay tutorial'),
)
```

---

## ✅ Validation Checklist

After migration, verify:

- [ ] All `FeatureHintOverlay` widgets have `uniqueKey`
- [ ] `customIcon` changed from IconData to Widget
- [ ] App builds without errors
- [ ] Overlays display correctly
- [ ] Animations play smoothly
- [ ] onCompleted callbacks work
- [ ] Storage permissions still work (for playOnceInLifetime)

---

## 🆘 Troubleshooting

### Issue: "The named parameter 'uniqueKey' is required"

**Solution:** Add `uniqueKey` to every `FeatureHintOverlay`:
```dart
FeatureHintOverlay(
  uniqueKey: 'my_hint_id', // ✅ Required now
  gesture: GestureType.tap,
  child: YourWidget(),
)
```

---

### Issue: "type 'IconData' can't be assigned to type 'Widget?'"

**Solution:** Wrap IconData in Icon widget:
```dart
// ❌ Before
customIcon: Icons.favorite

// ✅ After
customIcon: Icon(Icons.favorite)
```

---

### Issue: Animation doesn't play once even with playOnceInLifetime

**Solution:** Ensure `uniqueKey` is truly unique:
```dart
// ❌ Generic key (might get reused)
uniqueKey: 'hint'

// ✅ Unique key
uniqueKey: 'onboarding_welcome_step_1'
```

---

### Issue: "Unknown GestureType"

**Solution:** Use enum values, not strings:
```dart
// ❌ Wrong
gesture: 'swipeLeft'

// ✅ Correct
gesture: GestureType.swipeLeft
```

---

## 📚 Additional Resources

- **Full Features Guide**: See [FEATURES.md](FEATURES.md)
- **API Docs**: See [flutter_feature_hint dartdoc](lib/src/feature_hint_overlay.dart)
- **Example App**: Check [example/lib/main.dart](example/lib/main.dart)
- **Changelog**: See [CHANGELOG.md](CHANGELOG.md)

---

## 🎉 You're Done!

Your app is now upgraded to v0.2.0 with all the new features. Enjoy! 🚀

Have questions? Check the [README.md](README.md) or create an issue on GitHub.
