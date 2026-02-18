import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide language/locale provider persisted to SharedPreferences.
/// Stores a short language code: 'en', 'sw', 'fr'.
class LocaleNotifier extends StateNotifier<String> {
  static const _key = 'app_locale';

  LocaleNotifier() : super('en') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'en';
    state = code;
  }

  Future<void> setLocale(String code) async {
    if (state == code) return;
    state = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }
}

final appLocaleProvider = StateNotifierProvider<LocaleNotifier, String>((ref) => LocaleNotifier());

/// Helper to convert language code to a human friendly label.
String languageLabel(String? code) {
  switch (code) {
    case 'sw':
      return 'Swahili';
    case 'fr':
      return 'French';
    case 'en':
    default:
      return 'English';
  }
}
