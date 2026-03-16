import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Simple user cache stored in secure storage.
///
/// Used to persist the last authenticated user so that app modules / permissions
/// can be restored on cold-start even if the network is unavailable.
class UserLocalDataSource {
  final FlutterSecureStorage _storage;
  static const _key = 'user_data';

  UserLocalDataSource({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveUser(Map<String, dynamic> userJson) async {
    await _storage.write(key: _key, value: json.encode(userJson));
  }

  Future<Map<String, dynamic>?> readUser() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _key);
  }
}
