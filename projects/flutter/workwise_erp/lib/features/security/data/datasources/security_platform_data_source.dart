import 'package:flutter/services.dart';

/// Talks to the native side via a method channel to query device security flags.
class SecurityPlatformDataSource {
  static const _channel = MethodChannel('com.workwise.erp/security');

  /// Returns `true` when Android Developer Options is enabled.
  /// Always returns `false` on non-Android platforms.
  Future<bool> isDeveloperOptionsEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'isDeveloperOptionsEnabled',
      );
      return result ?? false;
    } on PlatformException {
      // If the native side throws for any reason, fail open (allow the user in)
      // rather than blocking indefinitely.
      return false;
    } on MissingPluginException {
      // Running on a platform without a registered handler (iOS, web, desktop).
      return false;
    }
  }
}
