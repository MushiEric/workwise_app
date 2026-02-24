import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/environment.dart';
import '../errors/exceptions.dart';
import '../models/tenant.dart';
import 'tenant_provider.dart';
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

  // environment-aware config (timeouts, retries, logging remain in EnvConfig)
  final env = EnvConfig.current;

  // tenant-aware baseUrl (runtime). Tenant must be set at app bootstrap.
  final tenant = ref.watch(tenantProvider);
  if (tenant == null) {
    // When the workspace is being switched the provider tree will re-evaluate
    // while the tenant is temporarily null. We don't want that to trigger an
    // uncaught exception during widget rebuilds; instead return a lightweight
    // Dio instance that will throw on any network call. This mirrors the
    // previous behaviour but defers the failure until the first request.
    final stub = Dio();
    stub.interceptors.add(InterceptorsWrapper(onRequest: (opts, handler) {
      handler.reject(DioException(
        requestOptions: opts,
        error: UninitializedTenantException(),
      ));
    }));
    return stub;
  }

  final options = BaseOptions(
    baseUrl: _normalizeBaseUrl(tenant.baseUrl),
    connectTimeout: env.connectTimeout,
    receiveTimeout: env.receiveTimeout,
    sendTimeout: env.sendTimeout,
  );

  final dio = Dio(options);

  // Attach a request-id for traceability (added to headers and `extra` so
  // downstream interceptors / Sentry / logs can correlate requests).
  String _generateRequestId() => '${DateTime.now().toUtc().toIso8601String()}-${Random().nextInt(1 << 32).toRadixString(16)}';

  dio.interceptors.add(InterceptorsWrapper(onRequest: (opts, handler) {
    final existing = opts.headers['X-Request-Id'] ?? opts.headers['x-request-id'];
    final id = existing?.toString() ?? _generateRequestId();
    opts.headers['X-Request-Id'] = id;
    opts.extra['requestId'] = id;
    handler.next(opts);
  }));

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

  // Retry interceptor (exponential backoff) with safety guards:
  // - do NOT retry when the request was cancelled by the user
  // - only retry idempotent methods (GET/HEAD/OPTIONS)
  // - refuse to retry when the request body is non-replayable (streams/files)
  dio.interceptors.add(InterceptorsWrapper(onError: (DioException err, handler) async {
    final opts = err.requestOptions;
    final method = opts.method.toUpperCase();

    // don't retry user-initiated cancellations — avoid hidden retries
    if (err.type == DioExceptionType.cancel) return handler.next(err);

    // only retry idempotent methods
    const idempotent = {'GET', 'HEAD', 'OPTIONS'};
    if (!idempotent.contains(method)) return handler.next(err);

    // protect against retrying non-replayable request bodies
    bool _isReplayableBody(Object? data) {
      if (data == null) return true;
      if (data is String || data is num || data is bool) return true;
      if (data is Map || data is List || data is List<int>) return true;
      if (data is FormData) {
        // FormData without files is replayable; with files it is not.
        return data.files.isEmpty;
      }
      // Streams, MultipartFile, and unknown types are treated as non-replayable
      return false;
    }

    if (!_isReplayableBody(opts.data)) return handler.next(err);

    final maxRetries = env.maxRetries;
    final retries = (opts.extra['__retry_count'] as int?) ?? 0;

    bool shouldRetry = false;

    // transient error kinds we consider retryable
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
  // Only enable HTTP logging for non-production environments.
  if (env.env != AppEnvironment.prod) {
    dio.interceptors.add(createLoggingInterceptor());
  }

  return dio;
});
