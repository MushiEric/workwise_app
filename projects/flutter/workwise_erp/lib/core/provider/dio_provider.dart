import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/environment.dart';
import 'token_provider.dart';
import 'cache_interceptor.dart';
import 'response_validation_interceptor.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

/// Provides a configured Dio instance for the app.
final dioProvider = Provider<Dio>((ref) {
  // normalize baseUrl so callers can provide values with or without scheme
  String _normalizeBaseUrl(String raw) {
    var s = raw.trim();
    if (!s.startsWith(RegExp(r'https?:\/\/'))) {
      s = 'https://$s';
    }
    // ensure we have a valid uri
    final uri = Uri.tryParse(s);
    if (uri == null || uri.scheme.isEmpty) throw ArgumentError('Invalid baseUrl: $raw');
    return s;
  }

  // environment-aware config
  final env = EnvConfig.current;

  final options = BaseOptions(
    baseUrl: _normalizeBaseUrl(env.baseUrl),
    connectTimeout: env.connectTimeout,
    receiveTimeout: env.receiveTimeout,
    sendTimeout: env.sendTimeout,
  );

  final dio = Dio(options);

  // Attach auth interceptor that injects Authorization header when token is present
  // Requests can opt-out of auth by passing `Options(extra: {'noAuth': true})`.
  dio.interceptors.add(AuthInterceptor(() async {
    final tokenStorage = ref.read(tokenLocalDataSourceProvider);
    return tokenStorage.readToken();
  }));

  // Cache interceptor: used for GET request graceful offline fallback
  dio.interceptors.add(CacheInterceptor(ttlSeconds: env.cacheTtlSeconds));

  // Validate responses expected to be JSON and reject HTML/error-pages so
  // they don't get cached or silently parsed.
  dio.interceptors.add(const ResponseValidationInterceptor());

  // Retry interceptor (simple, exponential backoff) for idempotent requests
  dio.interceptors.add(InterceptorsWrapper(onError: (DioException err, handler) async {
    final opts = err.requestOptions;
    final method = opts.method.toUpperCase();

    // only retry GET requests (idempotent)
    if (method != 'GET') return handler.next(err);

    final maxRetries = env.maxRetries;
    final retries = (opts.extra['__retry_count'] as int?) ?? 0;

    bool shouldRetry = false;

    // DioException types that are transient
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      shouldRetry = true;
    }

    final status = err.response?.statusCode ?? 0;
    if (status == 429 || (status >= 500 && status < 600)) shouldRetry = true;

    if (shouldRetry && retries < maxRetries) {
      final delayMs = env.retryBaseDelay.inMilliseconds * pow(2, retries).toInt();
      await Future<void>.delayed(Duration(milliseconds: delayMs));

      // update retry count and re-issue request
      opts.extra['__retry_count'] = retries + 1;
      try {
        final r = await dio.fetch(opts);
        return handler.resolve(r);
      } catch (e) {
        return handler.next(e as DioException);
      }
    }

    // report the last attempt to Sentry (if available)
    try {
      await Sentry.captureException(err, stackTrace: err.stackTrace);
    } catch (_) {}

    return handler.next(err);
  }));

  // Log requests/responses/errors to console (helpful during development)
  dio.interceptors.add(createLoggingInterceptor());

  return dio;
});
