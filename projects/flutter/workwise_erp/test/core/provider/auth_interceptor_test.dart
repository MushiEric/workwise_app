import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/core/provider/auth_interceptor.dart';

void main() {
  test('adds Authorization header when token present', () async {
    final interceptor = AuthInterceptor(() async => 'abc123');

    final opts = RequestOptions(path: '/foo');
    final handler = RequestInterceptorHandler();

    // onRequest is async but uses handler.next synchronously after awaiting token
    interceptor.onRequest(opts, handler);

    // Give the microtask loop a tick for async work to finish
    await Future<void>.delayed(Duration.zero);

    expect(opts.headers['Authorization'], 'Bearer abc123');
  });

  test('does not add Authorization when no token', () async {
    final interceptor = AuthInterceptor(() async => null);

    final opts = RequestOptions(path: '/foo');
    final handler = RequestInterceptorHandler();

    interceptor.onRequest(opts, handler);
    await Future<void>.delayed(Duration.zero);

    expect(opts.headers.containsKey('Authorization'), isFalse);
  });

  test('respects noAuth opt-out', () async {
    final interceptor = AuthInterceptor(() async => 'token');

    final opts = RequestOptions(path: '/foo', extra: {'noAuth': true});
    final handler = RequestInterceptorHandler();

    interceptor.onRequest(opts, handler);
    await Future<void>.delayed(Duration.zero);

    expect(opts.headers.containsKey('Authorization'), isFalse);
  });
}
