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
      title: 'Flutter Feature Hint Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({Key? key}) : super(key: key);

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  bool _showSwipeLeftHint = true;
  bool _showSwipeRightHint = false;
  bool _showTapHint = false;
  final List<String> items = List.generate(10, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      appBar: AppBar(
        title: const Text('Feature Hint Demo'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(items[index]),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              setState(() {
                items.removeAt(index);
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    direction == DismissDirection.endToStart
                        ? 'Swiped left!'
                        : 'Swiped right!',
                  ),
                ),
              );
              
              if (direction == DismissDirection.endToStart && _showSwipeLeftHint) {
                setState(() {
                  _showSwipeLeftHint = false;
                  _showSwipeRightHint = true;
                });
              } else if (direction == DismissDirection.startToEnd && _showSwipeRightHint) {
                setState(() {
                  _showSwipeRightHint = false;
                  _showTapHint = true;
                });
              }
            },
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.check, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(items[index]),
              subtitle: const Text('Swipe left or right'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            items.add('New Item ${items.length + 1}');
          });
        },
        child: const Icon(Icons.add),
      ),
    );

    // Layer hints in sequence
    if (_showSwipeLeftHint) {
      content = FeatureHintOverlay(
        message: "Swipe left to delete an item",
        gesture: GestureType.swipeLeft,
        showOverlay: true,
        onGestureCompleted: () {
          print("User learned swipe left!");
        },
        child: content,
      );
    } else if (_showSwipeRightHint) {
      content = FeatureHintOverlay(
        message: "Swipe right to mark as complete",
        gesture: GestureType.swipeRight,
        showOverlay: true,
        onGestureCompleted: () {
          print("User learned swipe right!");
        },
        child: content,
      );
    } else if (_showTapHint) {
      content = FeatureHintOverlay(
        message: "Tap the + button to add new items",
        gesture: GestureType.tap,
        showOverlay: true,
        messageAlignment: Alignment.topCenter,
        onGestureCompleted: () {
          setState(() {
            _showTapHint = false;
          });
          print("User learned tap!");
        },
        child: content,
      );
    }

    return content;
  }
}