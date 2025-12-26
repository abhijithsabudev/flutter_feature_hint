import 'package:flutter/material.dart';

/// Custom painter that creates a spotlight effect around a target widget
class SpotlightPainter extends CustomPainter {
  final GlobalKey targetKey;
  final Color overlayColor;
  final EdgeInsets spotlightPadding;
  
  SpotlightPainter({
    required this.targetKey,
    required this.overlayColor,
    required this.spotlightPadding,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Get the position and size of target widget
    final RenderBox? renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    
    if (renderBox == null) {
      // If target not found, just draw full overlay
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = overlayColor,
      );
      return;
    }
    
    final position = renderBox.localToGlobal(Offset.zero);
    final targetSize = renderBox.size;
    
    // Create spotlight rect with padding
    final spotlightRect = Rect.fromLTWH(
      position.dx - spotlightPadding.left,
      position.dy - spotlightPadding.top,
      targetSize.width + spotlightPadding.horizontal,
      targetSize.height + spotlightPadding.vertical,
    );
    
    // Draw full overlay
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = overlayColor,
    );
    
    // Cut out the spotlight area
    canvas.drawRRect(
      RRect.fromRectAndRadius(spotlightRect, const Radius.circular(8)),
      Paint()..blendMode = BlendMode.clear,
    );
    
    canvas.restore();
    
    // Draw border around spotlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(spotlightRect, const Radius.circular(8)),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }
  
  @override
  bool shouldRepaint(SpotlightPainter oldDelegate) => true;
}