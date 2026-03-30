abstract class ErrorReporter {
  /// Capture a thrown exception with the associated stack trace.
  Future<void> captureException(Object error, StackTrace stackTrace);

  /// Capture an arbitrary message (useful for informational events).
  Future<void> captureMessage(String message);
}
