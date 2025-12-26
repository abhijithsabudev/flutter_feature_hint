# Quick Start: Publishing to pub.dev and GitHub

This is a quick reference guide for publishing flutter_feature_hint v0.0.2.

## ⚡ Quick Steps

### Step 1: Add GIFs (2 mins)
```bash
# Copy your 6 GIF files to:
docs/gifs/
├── swipe_left.gif
├── swipe_right.gif
├── swipe_up.gif
├── swipe_down.gif
├── tap.gif
└── long_press.gif
```

See [GIF_GUIDE.md](GIF_GUIDE.md) for detailed instructions.

### Step 2: Verify pub.dev Readiness (1 min)
```bash
cd /Users/abhijithksabu/vensure/projects/personal/flutter_feature_hint
dart pub publish --dry-run
```

✅ Should report no errors and be ready to publish.

### Step 3: Publish to pub.dev (2 mins)
```bash
dart pub publish
```

Confirm when prompted. Visit: https://pub.dev/packages/flutter_feature_hint

### Step 4: Setup GitHub (5 mins)

#### First time only:
```bash
cd /Users/abhijithksabu/vensure/projects/personal/flutter_feature_hint
git init
git remote add origin https://github.com/yourusername/flutter_feature_hint.git
git branch -M main
```

#### Commit and push:
```bash
git add .
git commit -m "Initial release v0.0.2"
git push -u origin main
```

### Step 5: Create GitHub Release (2 mins)

1. Go to: https://github.com/yourusername/flutter_feature_hint/releases
2. Click "Create a new release"
3. Fill in:
   - **Tag**: v0.0.2
   - **Title**: flutter_feature_hint 0.0.2
   - **Body**: Copy from CHANGELOG.md (v0.0.2 section)
4. Click "Publish release"

## 📋 What Gets Published

### To pub.dev
- ✅ Package code (lib/)
- ✅ Example app (example/)
- ✅ Documentation (README.md)
- ✅ License (LICENSE)
- ✅ Changelog (CHANGELOG.md)
- ✅ GIFs (docs/gifs/)

### To GitHub
- ✅ All source code
- ✅ All documentation
- ✅ Example app
- ✅ GIFs
- ✅ License

## 🔍 Verification

### After pub.dev publishing:
```
Visit: https://pub.dev/packages/flutter_feature_hint
Check:
  ✅ Latest version shows 0.0.2
  ✅ GIFs display correctly
  ✅ README renders properly
  ✅ Documentation is complete
```

### After GitHub publishing:
```
Visit: https://github.com/yourusername/flutter_feature_hint
Check:
  ✅ Code is visible
  ✅ README displays properly
  ✅ GIFs appear in demo section
  ✅ Release v0.0.2 is listed
```

## ⚠️ Important Notes

### Version
- Current version: **0.0.2**
- Cannot be changed after publishing
- To update: must use 0.0.3 or higher

### GIFs
- Required for complete documentation
- Add before or immediately after publishing
- Can update package later without version change

### Credentials
- First publish requires Google account login
- Follow browser prompts for authentication
- Credentials cached locally

### Rollback
- Cannot unpublish after 24 hours
- Can yank versions if needed
- New version replaces old one on pub.dev

## 📞 Support

If you encounter issues:

1. **pub.dev publish fails**
   - Run: `dart pub publish --dry-run`
   - Check error messages
   - See PUBLISHING.md for troubleshooting

2. **Git authentication fails**
   - Ensure GitHub remote is correct
   - Check SSH key or personal access token
   - See GitHub documentation

3. **GIFs not displaying**
   - Check file paths (relative to root)
   - Verify files are committed: `git ls-files docs/gifs/`
   - Wait a few minutes for pub.dev/GitHub to cache

## 📊 Timeline

| Step | Time | Action |
|------|------|--------|
| 1 | 2 min | Add GIF files |
| 2 | 1 min | Verify with dry-run |
| 3 | 2 min | Publish to pub.dev |
| 4 | 5 min | Setup GitHub repo |
| 5 | 2 min | Create GitHub release |
| **Total** | **~12 min** | **Complete publication** |

## ✅ Final Checklist

Before running commands:
- [ ] All 6 GIF files are ready
- [ ] Package version is 0.0.2 in pubspec.yaml
- [ ] All documentation is complete
- [ ] No uncommitted changes
- [ ] GitHub username/token ready

After publishing:
- [ ] pub.dev page displays correctly
- [ ] GitHub repo is created
- [ ] Release v0.0.2 is listed
- [ ] GIFs appear in documentation
- [ ] README renders properly

## 🎉 You're Done!

Your package is now:
- ✅ Published on pub.dev
- ✅ Available on GitHub
- ✅ Documented with examples
- ✅ Displayed with GIF demonstrations
- ✅ Ready for developers to use

## Next Steps

1. Share with the Flutter community
2. Monitor for issues and feedback
3. Plan v0.0.3 with improvements
4. Consider v1.0.0 when API is stable

---

**Total publishing time: ~12 minutes** ⚡

For more details, see:
- [PUBLISHING.md](PUBLISHING.md) - Detailed guide
- [GIF_GUIDE.md](GIF_GUIDE.md) - GIF instructions
- [PUBLICATION_SUMMARY.md](PUBLICATION_SUMMARY.md) - Full checklist
