import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheInterceptor extends Interceptor {
  final int ttlSeconds;
  CacheInterceptor({this.ttlSeconds = 300});

  String _key(RequestOptions opts) => 'cache:${opts.method}:${opts.uri.toString()}';

  Future<void> _writeCache(RequestOptions opts, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = json.encode({'ts': DateTime.now().millisecondsSinceEpoch, 'data': data});
      await prefs.setString(_key(opts), payload);
    } catch (_) {
      // ignore cache write failures
    }
  }

  Future<dynamic> _readCache(RequestOptions opts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final s = prefs.getString(_key(opts));
      if (s == null) return null;
      final m = json.decode(s) as Map<String, dynamic>;
      final ts = m['ts'] as int?;
      final data = m['data'];
      if (ts == null) return null;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttlSeconds * 1000) {
        await prefs.remove(_key(opts));
        return null;
      }
      return data;
    } catch (_) {
      return null;
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Only serve cache for GET requests
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }
    // Allow callers to bypass cache by setting extra: {'no_cache': true}
    if (options.extra['no_cache'] == true) {
      return handler.next(options);
    }
    final cached = await _readCache(options);
    if (cached != null) {
      final response = Response(
        requestOptions: options,
        data: cached,
        statusCode: 200,
        statusMessage: 'OK (cached)',
      );
      return handler.resolve(response, true);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final opts = response.requestOptions;

    if (opts.method.toUpperCase() == 'GET' && response.statusCode == 200) {
      // Heuristic: only cache responses that look like JSON. Avoid caching
      // HTML error pages (some servers return HTML on auth failures).
      final contentType = response.headers.value('content-type')?.toLowerCase() ?? '';
      final data = response.data;

      final looksJson = () {
        if (contentType.contains('application/json')) return true;
        if (data is Map || data is List) return true;
        if (data is String) {
          final s = data.trimLeft();
          if (s.isEmpty) return false;
          if (s.startsWith('<')) return false; // likely HTML
          try {
            json.decode(s);
            return true;
          } catch (_) {
            return false;
          }
        }
        return false; // conservative
      }();

      if (looksJson) {
        try {
          final serializable = response.data;
          _writeCache(opts, serializable);
        } catch (_) {}
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final opts = err.requestOptions;
    // only attempt cache fallback for GET requests
    if (opts.method.toUpperCase() == 'GET') {
      final cached = await _readCache(opts);
      if (cached != null) {
        final r = Response(requestOptions: opts, data: cached, statusCode: 200);
        return handler.resolve(r);
      }
    }

    handler.next(err);
  }
}
