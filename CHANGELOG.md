## 0.1.0 - 2025-12-26

### ✨ Major Features
- **Full-Screen Overlay System**: Overlays now cover the entire screen while precisely positioning the animation icon over the wrapped widget
- **Auto-Playing Animations**: Animations play automatically without requiring user interaction
- **Enhanced Widget Message System**: Changed message parameter from String to Widget for maximum flexibility and custom styling
- **Smooth Fade Animations**: Implemented FadeTransition for professional fade in/out effects
- **Responsive Design**: Works seamlessly with widgets of any size, from tiny buttons to entire lists
- **Complete Position Tracking**: Animation icon automatically positions over the wrapped widget using Transform.translate

### 🎨 UI/UX Improvements
- Beautiful example app with Material 3 design
- Modern gradient themes and card-based layouts
- Enhanced visual feedback with smooth transitions
- Professional message box styling with shadows and elevation
- Improved icon animations with gesture-specific directions

### 🔧 Code Quality
- Comprehensive dartdoc comments on all public APIs
- Input validation with assertions for duration and icon size
- Proper resource cleanup in dispose()
- Safe render box access with hasSize checks
- Try-catch protection for layout edge cases

### 📚 Documentation
- Complete README with usage examples and customization guide
- Detailed parameter documentation
- Architecture and how-it-works explanation
- Troubleshooting guide for common issues
- Example app demonstrating all features

## 0.0.1 - Initial Release

- Initial release with basic gesture hint functionality
- Support for 6 gesture types (swipe left/right/up/down, tap, long press)
- Animated hand gestures
- Customizable overlay appearance
- Basic message display
