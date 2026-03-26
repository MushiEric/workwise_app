import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:workwise_erp/core/errors/sentry_error_reporter.dart';

/// Ensures API responses expected to be JSON actually are JSON.
///
/// - Default behavior: all requests are treated as `expectJson=true` unless the
///   caller sets `requestOptions.extra['expectJson'] = false` (opt-out).
/// - If a response looks like HTML (content-type `text/html` or body starts
///   with `<`) the interceptor rejects with a `DioException` (type `badResponse`).
/// - If the response `data` is a `String` containing JSON, it will be decoded
///   so callers receive parsed `Map`/`List` as usual.
class ResponseValidationInterceptor extends Interceptor {
  const ResponseValidationInterceptor();

  bool _looksLikeJson(Response response) {
    final contentType = response.headers.value('content-type')?.toLowerCase();

    // If server explicitly says JSON, accept it.
    if (contentType != null && contentType.contains('application/json')) return true;

    final d = response.data;
    if (d is Map || d is List) return true;

    if (d is String) {
      final s = d.trimLeft();
      // obvious HTML -> not JSON
      if (s.startsWith('<')) return false;
      // try to parse string as JSON (conservative)
      try {
        json.decode(s);
        return true;
      } catch (_) {
        return false;
      }
    }

    // conservative default: not JSON
    return false;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final opts = response.requestOptions;

    // allow per-request opt-out for endpoints that legitimately return HTML/text
    final expectJson = opts.extra['expectJson'];
    if (expectJson != null && expectJson == false) return handler.next(response);

    // validate response looks like JSON; if not, reject so upper layers can
    // handle it instead of silently parsing HTML as JSON.
    if (!_looksLikeJson(response)) {
      final msg = 'Non-JSON response from ${opts.uri} (content-type: ${response.headers.value('content-type')})';
      final err = DioException(
        requestOptions: opts,
        response: response,
        error: msg,
        type: DioExceptionType.badResponse,
      );

      // record telemetry for investigation (best-effort)
      try {
         SentryErrorReporter().captureException(err, err.stackTrace ?? StackTrace.current);
      } catch (_) {}

      return handler.reject(err);
    }

    // if data is a JSON-encoded string, decode it so callers get parsed object
    if (response.data is String) {
      try {
        response.data = json.decode(response.data as String);
      } catch (_) {
        // decoding failed — leave it to callers, but validation above should
        // have prevented most non-JSON strings.
      }
    }

    handler.next(response);
  }
}
