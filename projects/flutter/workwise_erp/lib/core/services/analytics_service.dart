import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ── Crashlytics ────────────────────────────────────────────────────────────

  static Future<void> initCrashlytics() async {
    // Disable Crashlytics collection in debug mode
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    // Forward all Flutter framework errors to Crashlytics
    FlutterError.onError = _crashlytics.recordFlutterFatalError;

    // Forward Dart async errors (e.g. in isolates / zones) to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static Future<void> setUserId(String? userId) async {
    await _crashlytics.setUserIdentifier(userId ?? '');
    await _analytics.setUserId(id: userId);
  }

  static Future<void> setUserProperty(String name, String value) async {
    await _crashlytics.setCustomKey(name, value);
    await _analytics.setUserProperty(name: name, value: value);
  }

  static void recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
    String? reason,
  }) {
    _crashlytics.recordError(exception, stack, fatal: fatal, reason: reason);
  }

  // ── Analytics — Screen tracking ────────────────────────────────────────────

  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // ── Analytics — Auth events ────────────────────────────────────────────────

  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  static Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
  }

  // ── Analytics — Job Card events ────────────────────────────────────────────

  static Future<void> logJobCardViewed(String jobCardId) async {
    await _analytics.logEvent(
      name: 'jobcard_viewed',
      parameters: {'jobcard_id': jobCardId},
    );
  }

  static Future<void> logJobCardCreated() async {
    await _analytics.logEvent(name: 'jobcard_created');
  }

  // ── Analytics — Support events ─────────────────────────────────────────────

  static Future<void> logTicketViewed(String ticketId) async {
    await _analytics.logEvent(
      name: 'ticket_viewed',
      parameters: {'ticket_id': ticketId},
    );
  }

  static Future<void> logTicketCreated(String category) async {
    await _analytics.logEvent(
      name: 'ticket_created',
      parameters: {'category': category},
    );
  }

  static Future<void> logAiChatOpened() async {
    await _analytics.logEvent(name: 'ai_chat_opened');
  }

  // ── Analytics — Generic custom event ───────────────────────────────────────

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
