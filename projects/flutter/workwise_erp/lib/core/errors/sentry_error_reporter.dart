import 'package:sentry_flutter/sentry_flutter.dart';

import 'error_reporter.dart';

class SentryErrorReporter implements ErrorReporter {
  const SentryErrorReporter();

  @override
  Future<void> captureException(Object error, StackTrace stackTrace) async {
    try {
      await Sentry.captureException(error, stackTrace: stackTrace);
    } catch (_) {
      // best-effort; do not fail the app if Sentry fails.
    }
  }

  @override
  Future<void> captureMessage(String message) async {
    try {
      await Sentry.captureMessage(message);
    } catch (_) {
      // best-effort; do not fail the app if Sentry fails.
    }
  }
}
