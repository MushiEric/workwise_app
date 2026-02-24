import 'package:shared_preferences/shared_preferences.dart';

/// Simple SharedPreferences-backed storage for the active tenant (API baseUrl).
class TenantLocalDataSource {
  static const _key = 'tenant_base_url';
  final SharedPreferences? _prefs;

  TenantLocalDataSource({SharedPreferences? prefs}) : _prefs = prefs;

  Future<void> saveTenant(String baseUrl) async {
    final p = _prefs ?? await SharedPreferences.getInstance();
    await p.setString(_key, baseUrl);
  }

  Future<String?> readTenant() async {
    final p = _prefs ?? await SharedPreferences.getInstance();
    return p.getString(_key);
  }

  Future<void> clearTenant() async {
    final p = _prefs ?? await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
