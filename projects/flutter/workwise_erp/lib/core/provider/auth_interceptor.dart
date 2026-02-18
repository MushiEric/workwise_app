import 'package:dio/dio.dart';

/// An interceptor that injects a Bearer token into request headers.
///
/// The interceptor accepts a `Future<String?> Function()` that returns the
/// current token; callers may opt out of authentication by setting
/// `requestOptions.extra['noAuth'] = true`.
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() _getToken;

  AuthInterceptor(Future<String?> Function() getToken) : _getToken = getToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // allow explicit opt-out for endpoints that don't require a token
    if (options.extra['noAuth'] == true) return handler.next(options);

    try {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // swallow token errors; request should continue without auth header
    }

    handler.next(options);
  }
}
