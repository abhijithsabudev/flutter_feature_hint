// Example implementation showing the playOnceInLifetime feature in action

import 'package:flutter/material.dart';
import 'package:flutter_feature_hint/flutter_feature_hint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play Once in Lifetime Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _showHints = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Hints Demo'),
        actions: [
          // Button to reset hints for demonstration
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              AnimationStateManager.resetAllAnimations();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('All hints reset!')));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Example 1: Swipe to delete hint - plays only once
          _buildSwipeDeleteExample(),
          const Divider(),

          // Example 2: Tap to expand hint - plays only once
          _buildTapToExpandExample(),
          const Divider(),

          // Example 3: Multiple items with individual hints
          _buildMultipleItemsExample(),
          const Divider(),

          // Example 4: Hint that plays every time (no playOnceInLifetime)
          _buildRepeatingHintExample(),
          const Divider(),

          // Debug info
          _buildDebugInfo(),
        ],
      ),
    );
  }

  /// Example 1: Swipe to delete with playOnceInLifetime enabled
  Widget _buildSwipeDeleteExample() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example 1: Swipe to Delete (Plays Once)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          FeatureHintOverlay(
            uniqueKey: 'swipe_delete_hint',
            playOnceInLifetime: true,
            shouldPlay: _showHints,
            message: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '👈 Swipe left to delete',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            gesture: GestureType.swipeLeft,
            duration: const Duration(seconds: 3),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Swipe me left to delete'),
            ),
            onCompleted: () {
              print('Swipe delete hint completed');
            },
          ),
        ],
      ),
    );
  }

  /// Example 2: Tap to expand with playOnceInLifetime enabled
  Widget _buildTapToExpandExample() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example 2: Tap to Expand (Plays Once)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          FeatureHintOverlay(
            uniqueKey: 'tap_expand_hint',
            playOnceInLifetime: true,
            shouldPlay: _showHints,
            message: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '👆 Tap to expand',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            gesture: GestureType.tap,
            duration: const Duration(seconds: 3),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Tap me to expand'),
            ),
            onCompleted: () {
              print('Tap expand hint completed');
            },
          ),
        ],
      ),
    );
  }

  /// Example 3: Multiple items each with their own hint
  Widget _buildMultipleItemsExample() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example 3: Multiple Items (Each Plays Once)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildItemWithHint(
            key: 'item_1_swipe_hint',
            label: 'Item 1',
            gesture: GestureType.swipeRight,
            message: '👉 Swipe right to archive',
          ),
          const SizedBox(height: 8),
          _buildItemWithHint(
            key: 'item_2_swipe_hint',
            label: 'Item 2',
            gesture: GestureType.swipeLeft,
            message: '👈 Swipe left to delete',
          ),
          const SizedBox(height: 8),
          _buildItemWithHint(
            key: 'item_3_double_tap_hint',
            label: 'Item 3',
            gesture: GestureType.longPress,
            message: '👆👆 Double tap to pin',
          ),
        ],
      ),
    );
  }

  Widget _buildItemWithHint({
    required String key,
    required String label,
    required GestureType gesture,
    required String message,
  }) {
    return FeatureHintOverlay(
      uniqueKey: key,
      playOnceInLifetime: true,
      shouldPlay: _showHints,
      message: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.shade700,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      gesture: gesture,
      duration: const Duration(seconds: 2),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label),
      ),
    );
  }

  /// Example 4: Hint that plays every time (no playOnceInLifetime)
  Widget _buildRepeatingHintExample() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example 4: Repeating Hint (Plays Every Time)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          FeatureHintOverlay(
            uniqueKey: 'repeating_hint',
            // playOnceInLifetime: false (default)
            // This hint will play every time the widget rebuilds
            shouldPlay: _showHints,
            message: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '✨ This hint plays every time',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            gesture: GestureType.tap,
            duration: const Duration(seconds: 2),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('I will show this hint every time'),
            ),
          ),
        ],
      ),
    );
  }

  /// Debug information showing the state of animations
  Widget _buildDebugInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Debug Info',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Animations Played: ${AnimationStateManager.playedAnimationsCount}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Played Keys:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                ...AnimationStateManager.playedAnimations.map(
                  (key) =>
                      Text('  • $key', style: const TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  AnimationStateManager.resetAllAnimations();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All hints have been reset!')),
                  );
                },
                child: const Text('Reset All Hints'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showHints = !_showHints;
                  });
                },
                child: Text(_showHints ? 'Disable Hints' : 'Enable Hints'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
