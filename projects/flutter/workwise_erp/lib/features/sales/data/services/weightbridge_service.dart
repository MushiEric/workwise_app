import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Result returned by the local weighbridge REST service.
class WeightbridgeResult {
  final double weight;
  final bool stable;
  final String unit;
  final bool ready;
  final String time;

  const WeightbridgeResult({
    required this.weight,
    required this.stable,
    required this.unit,
    required this.ready,
    required this.time,
  });

  factory WeightbridgeResult.fromJson(Map<String, dynamic> json) {
    return WeightbridgeResult(
      weight: (json['weight'] as num).toDouble(),
      stable: json['stable'] as bool? ?? false,
      unit: (json['unit'] as String?) ?? 'kg',
      ready: json['ready'] as bool? ?? false,
      time: (json['time'] as String?) ?? '',
    );
  }
}

/// Manages communication with the local weighbridge Node/Express service
/// running on the same LAN (GET http://<ip>:5558/api/current-weight).
///
/// The IP address and manual-override flag are stored in SharedPreferences
/// so they survive app restarts.
class WeightbridgeService {
  static const _ipKey = 'weightbridge_ip';
  static const _manualKey = 'weightbridge_manual_override';
  static const _port = 5558;

  // Dedicated Dio instance — no auth or app interceptors needed.
  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  // ── Preferences ──────────────────────────────────────────────────────────

  Future<String> getIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ipKey) ?? '';
  }

  Future<void> saveIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ipKey, ip.trim());
  }

  Future<bool> getManualOverride() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_manualKey) ?? false;
  }

  Future<void> saveManualOverride(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_manualKey, value);
  }

  // ── Weight fetch ──────────────────────────────────────────────────────────

  /// Fetches the current reading from the weighbridge service.
  ///
  /// Throws an [Exception] when:
  /// - No IP has been configured yet.
  /// - The HTTP call fails (network error, timeout, non-2xx status).
  /// - The response body cannot be parsed.
  Future<WeightbridgeResult> fetchWeight() async {
    final ip = await getIp();
    if (ip.isEmpty) {
      throw Exception('Weighbridge IP not configured');
    }

    final url = 'http://$ip:$_port/api/current-weight';
    final response = await _dio.get<Map<String, dynamic>>(url);

    if (response.data == null) {
      throw Exception('Empty response from weighbridge');
    }

    return WeightbridgeResult.fromJson(response.data!);
  }
}
