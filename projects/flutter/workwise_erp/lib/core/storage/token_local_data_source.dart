import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenLocalDataSource {
  final FlutterSecureStorage _storage;
  static const _key = 'auth_token';

  TokenLocalDataSource({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  Future<String?> readToken() async {
    return await _storage.read(key: _key);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _key);
  }
}
