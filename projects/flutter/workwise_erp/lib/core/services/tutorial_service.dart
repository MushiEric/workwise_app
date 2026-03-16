import 'package:shared_preferences/shared_preferences.dart';

/// Helpers for tracking whether the app has already shown the onboarding tutorial.
///
/// The tutorial is shown once per user and then skipped on future app launches.
class TutorialService {
  static const _hasSeenTutorialKey = 'hasSeenTutorial';
  static const _hasSeenJobcardTutorialKey = 'hasSeenJobcardTutorial';

  static Future<bool> hasSeenTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenTutorialKey) ?? false;
  }

  static Future<void> markTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenTutorialKey, true);
  }

  static Future<bool> hasSeenJobcardTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenJobcardTutorialKey) ?? false;
  }

  static Future<void> markJobcardTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenJobcardTutorialKey, true);
  }

  /// Reset all tutorial flags (useful for QA/dev).
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasSeenTutorialKey);
    await prefs.remove(_hasSeenJobcardTutorialKey);
  }
}
