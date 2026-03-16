import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide language/locale provider persisted to SharedPreferences.
/// Stores a short language code: 'en', 'sw', 'fr'.
class LocaleNotifier extends StateNotifier<String> {
  static const _key = 'app_locale';

  /// Tracks whether we've loaded the persisted locale already.
  ///
  /// This prevents a late-running initial load from overwriting a user-initiated
  /// locale change that happens while the initial load is still in progress.
  bool _hasLoaded = false;

  LocaleNotifier() : super('en') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'en';

    // If the locale has already been set via setLocale (e.g. user tapped a
    // language option before the initial load completed), don't override it.
    if (_hasLoaded) return;

    state = code;
    _hasLoaded = true;
  }

  Future<void> setLocale(String code) async {
    if (state == code) return;
    state = code;
    _hasLoaded = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }
}

final appLocaleProvider = StateNotifierProvider<LocaleNotifier, String>(
  (ref) => LocaleNotifier(),
);

/// Helper to convert language code to a human friendly label.
String languageLabel(String? code) {
  switch (code) {
    case 'sw':
      return 'Swahili';
    case 'fr':
      return 'French';
    case 'hi':
      return 'Hindi';
    case 'en':
    default:
      return 'English';
  }
}

/// Helper to return a flag emoji (or null) for a language code.
String? languageFlag(String? code) {
  switch (code) {
    case 'en':
      return '🇬🇧';
    case 'sw':
      return '🇹🇿';
    case 'fr':
      return '🇫🇷';
    case 'hi':
      return '🇮🇳';
    default:
      return null;
  }
}
