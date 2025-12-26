# Publishing Guide

This guide will help you publish `flutter_feature_hint` to pub.dev and manage the GitHub repository.

## Pre-Publication Checklist

- [x] All Dart files formatted with `dart format`
- [x] Documentation complete (README.md, CHANGELOG.md, LICENSE)
- [x] Example app created and tested
- [x] Version number updated in pubspec.yaml
- [x] GIF demonstrations ready (place in docs/gifs/)
- [x] .gitignore configured
- [x] No unnecessary files committed

## Adding GIF Demonstrations

Place your GIF files in the `docs/gifs/` directory:

```
docs/gifs/
├── swipe_left.gif
├── swipe_right.gif
├── swipe_up.gif
├── swipe_down.gif
├── tap.gif
└── long_press.gif
```

GIF Specifications:
- Size: ~200x400 pixels (portrait orientation)
- Format: Animated GIF
- Duration: 2-3 seconds per loop
- Quality: Optimized for web (reduced file size)

## Publishing to pub.dev

### 1. Setup (First Time Only)

```bash
# Activate pub credentials
dart pub publish --dry-run

# Authenticate with pub.dev
# Follow the browser prompts to log in with your Google account
```

### 2. Pre-Publication Check

```bash
# Run pub publish in dry-run mode to check for issues
dart pub publish --dry-run

# This will check:
# - Package structure
# - pubspec.yaml validity
# - README and LICENSE presence
# - Dart code quality
# - Dependencies
```

### 3. Publish

```bash
# Publish the package
dart pub publish

# Confirm the publication when prompted
```

### 4. Verify

Visit https://pub.dev/packages/flutter_feature_hint to verify the package is published.

## Updating GitHub

### Initial Setup

```bash
# Initialize git (if not already done)
git init

# Add remote
git remote add origin https://github.com/yourusername/flutter_feature_hint.git

# Create main branch
git branch -M main
```

### Publishing Updates

```bash
# Check status
git status

# Stage changes
git add .

# Commit with meaningful message
git commit -m "v0.0.2: Add full-screen overlays and smooth animations"

# Push to GitHub
git push -u origin main

# Create a release on GitHub
# - Go to https://github.com/yourusername/flutter_feature_hint/releases
# - Click "Create a new release"
# - Tag version: v0.0.2
# - Title: flutter_feature_hint 0.0.2
# - Add release notes from CHANGELOG.md
```

## Important Files for Publication

### Required
- ✅ pubspec.yaml - Package metadata
- ✅ lib/ - Package source code
- ✅ LICENSE - MIT License
- ✅ README.md - Comprehensive documentation

### Recommended
- ✅ CHANGELOG.md - Version history
- ✅ example/ - Working example app
- ✅ docs/ - Additional documentation and assets

### Optional
- ✅ .gitignore - Version control
- ❌ .idea/ - IDE configuration (should be in .gitignore)
- ❌ build/ - Build artifacts (should be in .gitignore)

## Version Numbering

Current version: 0.0.2

Future versions follow semantic versioning:
- 0.0.3 - Bug fixes and minor improvements
- 0.1.0 - New features or breaking API changes
- 0.2.0 - Major feature additions
- 1.0.0 - Stable API release

Update version in:
1. pubspec.yaml (version field)
2. CHANGELOG.md (new version section)

## Troubleshooting

### Package rejected during publish

Common issues:
- Missing or invalid LICENSE
- README.md not found
- pubspec.yaml has errors
- Dart code style issues

Run `dart pub publish --dry-run` to identify issues.

### Version conflict

If you see "Version X.X.X is already published":
- You must increment the version number
- You cannot republish the same version
- Update pubspec.yaml and CHANGELOG.md

### Authentication issues

```bash
# Clear cached credentials
dart pub logout

# Re-authenticate
dart pub publish --dry-run
```

## Documentation Quality

Good documentation includes:
- Clear description in pubspec.yaml
- Comprehensive README.md with examples
- Working example application
- CHANGELOG.md with version history
- Proper dartdoc comments in code

## Post-Publication

After publishing:

1. **Monitor ratings and reviews** - Visit pub.dev/packages/flutter_feature_hint
2. **Respond to issues** - Watch for GitHub issues
3. **Update documentation** - Fix typos and clarify confusing sections
4. **Gather feedback** - Listen to user suggestions
5. **Plan next version** - Based on feedback and new features

## Resources

- [pub.dev publishing guide](https://dart.dev/tools/pub/publishing)
- [Effective Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter package guidelines](https://flutter.dev/docs/development/packages-and-plugins/developing-packages)
