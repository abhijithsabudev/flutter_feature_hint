import 'package:shared_preferences/shared_preferences.dart';

/// Manages the state of animations for widgets with [playOnceInLifetime] enabled.
///
/// This state manager persists animation state to device storage using
/// SharedPreferences. This ensures that animations truly play only once
/// across app sessions (even after closing and reopening the app).
///
/// The state is stored under the key prefix 'flutter_feature_hint_animation_'
class AnimationStateManager {
  /// Storage key prefix for animations
  static const String _storageKeyPrefix = 'flutter_feature_hint_animation_';

  /// In-memory cache for faster lookups (synced with SharedPreferences)
  static final Set<String> _playedAnimationsCache = {};

  /// Track keys that have been registered to detect duplicates
  static final Set<String> _registeredKeys = {};

  /// Flag to track if the cache has been initialized
  static bool _initialized = false;

  /// Future to track initialization in progress (prevents race conditions)
  static Future<void>? _initializationFuture;

  /// Enable debug logging
  static bool _debugLogging = false;

  /// Initializes the cache from SharedPreferences.
  ///
  /// This is called automatically on first use. Manual initialization is
  /// rarely needed unless you want to refresh the cache.
  ///
  /// Thread-safe: Uses a lock to prevent concurrent initialization.
  static Future<void> _ensureInitialized() async {
    // Fast path: already initialized
    if (_initialized) return;

    // Prevent race condition: if initialization is in progress, wait for it
    if (_initializationFuture != null) {
      await _initializationFuture;
      return;
    }

    // Create a completer for this initialization
    final initFuture = _doInitialize();
    _initializationFuture = initFuture;

    try {
      await initFuture;
    } finally {
      _initializationFuture = null;
    }
  }

  /// Internal method that performs the actual initialization.
  /// Should only be called by _ensureInitialized().
  static Future<void> _doInitialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      // Load all animation keys from storage
      for (final key in keys) {
        if (key.startsWith(_storageKeyPrefix)) {
          final animationKey = key.replaceFirst(_storageKeyPrefix, '');
          _playedAnimationsCache.add(animationKey);
        }
      }

      _log(
        'Initialized: Loaded ${_playedAnimationsCache.length} animations from storage',
      );
      _initialized = true;
    } catch (e, stackTrace) {
      // If SharedPreferences fails, DON'T mark as initialized
      // This allows retry on next call
      _logError('Failed to initialize from storage', e, stackTrace);
      _log('Continuing with in-memory cache (storage will be retried)');
      _initialized = false;
      rethrow; // Let caller handle the error
    }
  }

  /// Checks if an animation with the given [uniqueKey] has already been played.
  ///
  /// Returns `true` if the animation has already completed, `false` otherwise.
  /// This check includes state from previous app sessions.
  static Future<bool> hasAnimationPlayed(String uniqueKey) async {
    // Validate key
    if (!_validateKey(uniqueKey)) {
      return false;
    }

    try {
      await _ensureInitialized();
    } catch (e) {
      // If initialization fails, assume animation hasn't played (safe default)
      // This prevents animations from being permanently blocked
      _logWarning(
        'State Check Failed',
        'Could not determine if animation was played. Allowing animation to play.',
      );
      return false;
    }

    return _playedAnimationsCache.contains(uniqueKey);
  }

  /// Synchronously checks if an animation has been played (requires pre-initialization).
  ///
  /// Use this only after calling [initializeAsync] or [hasAnimationPlayed].
  /// For safety, prefer using [hasAnimationPlayed] which handles initialization.
  static bool hasAnimationPlayedSync(String uniqueKey) {
    if (!_initialized) {
      throw StateError(
        'AnimationStateManager not initialized. Call hasAnimationPlayed() first.',
      );
    }
    return _playedAnimationsCache.contains(uniqueKey);
  }

  /// Marks an animation with the given [uniqueKey] as played.
  ///
  /// This is called internally when an animation completes. The state is
  /// persisted to device storage to survive app restarts.
  static Future<void> markAnimationAsPlayed(String uniqueKey) async {
    // Validate key
    if (!_validateKey(uniqueKey)) {
      return;
    }

    try {
      await _ensureInitialized();
    } catch (e) {
      // If initialization fails, still track in memory
      _logWarning(
        'Storage Unavailable',
        'Animation state will be tracked in memory only (not persisted).',
      );
    }

    // Check for duplicate keys (warn if multiple widgets use same key)
    _checkForDuplicateKey(uniqueKey);

    // Update cache
    _playedAnimationsCache.add(uniqueKey);

    // Persist to storage (but don't fail if it doesn't work)
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setBool('$_storageKeyPrefix$uniqueKey', true);
      if (success) {
        _log('Marked as played and persisted: $uniqueKey');
      } else {
        _logWarning(
          'Storage Write Failed',
          'Animation marked in memory but may not persist across restarts.',
        );
      }
    } catch (e, stackTrace) {
      // If storage fails, animation is still tracked in memory for this session
      _logError('Failed to mark animation as played', e, stackTrace);
    }
  }

  /// Resets the animation state for the given [uniqueKey].
  ///
  /// This allows the animation to play again if needed. Useful for testing
  /// or if you want to allow the animation to replay.
  static Future<void> resetAnimation(String uniqueKey) async {
    if (!_validateKey(uniqueKey)) {
      return;
    }

    try {
      await _ensureInitialized();
    } catch (e) {
      // If initialization fails, just reset memory cache
    }

    // Update cache
    _playedAnimationsCache.remove(uniqueKey);

    // Remove from storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_storageKeyPrefix$uniqueKey');
      _log('Reset animation: $uniqueKey');
    } catch (e, stackTrace) {
      // If storage fails, animation is still reset in memory for this session
      _logError('Failed to reset animation', e, stackTrace);
    }
  }

  /// Resets all animations that have been played.
  ///
  /// This clears both in-memory cache and persistent storage.
  /// Use with caution as it will allow all animations to play again.
  static Future<void> resetAllAnimations() async {
    try {
      await _ensureInitialized();
    } catch (e) {
      // If initialization fails, just reset memory cache
    }

    // Clear cache
    _playedAnimationsCache.clear();

    // Clear from storage
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs
          .getKeys()
          .toList(); // Create a list copy to avoid iteration issues
      int removed = 0;

      for (final key in keys) {
        if (key.startsWith(_storageKeyPrefix)) {
          await prefs.remove(key);
          removed++;
        }
      }
      _log('Reset all animations ($removed removed from storage)');
    } catch (e, stackTrace) {
      // If storage fails, cache is still cleared in memory
      _logError('Failed to reset all animations', e, stackTrace);
    }
  }

  /// Explicitly initializes the animation state manager.
  ///
  /// This loads the animation state from persistent storage. Called
  /// automatically on first use, but can be called manually to ensure
  /// state is loaded before use (e.g., in main()).
  static Future<void> initializeAsync() async {
    await _ensureInitialized();
  }

  /// Enables or disables debug logging.
  ///
  /// Useful for development to see what's happening internally.
  static void setDebugLogging(bool enabled) {
    _debugLogging = enabled;
    _log('Debug logging ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Returns the number of animations that have been played.
  ///
  /// Useful for debugging purposes. Note: requires initialization.
  static int get playedAnimationsCount {
    if (!_initialized) {
      throw StateError(
        'AnimationStateManager not initialized. Call initializeAsync() first.',
      );
    }
    return _playedAnimationsCache.length;
  }

  /// Returns a copy of the set of played animation keys.
  ///
  /// Useful for debugging purposes. Note: requires initialization.
  static Set<String> get playedAnimations {
    if (!_initialized) {
      throw StateError(
        'AnimationStateManager not initialized. Call initializeAsync() first.',
      );
    }
    return Set.from(_playedAnimationsCache);
  }

  // ============ Private Helper Methods ============

  /// Validates animation key format.
  static bool _validateKey(String uniqueKey) {
    if (uniqueKey.isEmpty) {
      _logError('Invalid key', 'Key cannot be empty', null);
      return false;
    }

    if (uniqueKey.length > 256) {
      _logError('Invalid key', 'Key exceeds 256 characters', null);
      return false;
    }

    // Check for invalid characters
    if (!RegExp(r'^[a-zA-Z0-9_\-\.]+$').hasMatch(uniqueKey)) {
      _logError(
        'Invalid key',
        'Key contains invalid characters. Use only: a-z, A-Z, 0-9, _, -, .',
        null,
      );
      return false;
    }

    return true;
  }

  /// Checks for duplicate key registration and warns if found.
  static void _checkForDuplicateKey(String uniqueKey) {
    if (_registeredKeys.contains(uniqueKey)) {
      _logWarning(
        'Duplicate Key Detected',
        'Multiple FeatureHintOverlay widgets are using the same uniqueKey: "$uniqueKey". '
            'This can cause unexpected behavior. Each animation should have a unique key.',
      );
    } else {
      _registeredKeys.add(uniqueKey);
    }
  }

  /// Logs a message if debug logging is enabled.
  static void _log(String message) {
    if (_debugLogging) {
      print('[AnimationStateManager] ✓ $message');
    }
  }

  /// Logs a warning message.
  static void _logWarning(String title, String message) {
    print('[AnimationStateManager] ⚠️  WARNING: $title');
    print('   → $message');
  }

  /// Logs an error message.
  static void _logError(String message, dynamic error, StackTrace? stackTrace) {
    print('[AnimationStateManager] ❌ ERROR: $message');
    print('   → $error');
    if (stackTrace != null && _debugLogging) {
      print('   → Stack trace: $stackTrace');
    }
  }
}
