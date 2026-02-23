import 'dart:typed_data';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/core/config/environment.dart';
import 'package:workwise_erp/core/models/tenant.dart';
import 'package:workwise_erp/core/provider/dio_provider.dart';
import 'package:workwise_erp/core/provider/tenant_provider.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/provider/token_provider.dart';
import 'package:workwise_erp/core/storage/token_local_data_source.dart';

class _FakeTokenLocalDataSource extends TokenLocalDataSource {
  _FakeTokenLocalDataSource();

  @override
  Future<String?> readToken() async => null;

  @override
  Future<void> saveToken(String token) async {}

  @override
  Future<void> deleteToken() async {}
}

// Adapters used by tests below -------------------------------------------------
class _CountingAdapter implements HttpClientAdapter {
  int calls = 0;
  final DioException exception;
  _CountingAdapter(this.exception);

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<dynamic>? cancelFuture) async {
    calls++;
    throw exception;
  }
}

class _CaptureAdapter implements HttpClientAdapter {
  RequestOptions? captured;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<dynamic>? cancelFuture) async {
    captured = options;
    return ResponseBody.fromString('{"ok":true}', 200, headers: {"content-type": ["application/json; charset=utf-8"]});
  }
}

void main() {
  setUp(() {
    EnvConfig.resetOverride();
  });

  tearDown(() {
    EnvConfig.resetOverride();
  });

  test('adds LogInterceptor in non-prod environments', () {
    EnvConfig.init(AppEnvironment.dev);

    final container = ProviderContainer(overrides: [
      tokenLocalDataSourceProvider.overrideWithValue(_FakeTokenLocalDataSource()),
      tenantProvider.overrideWith((ref) => const Tenant('https://api.test/api')),
    ]);

    final dio = container.read(dioProvider);
    expect(dio.interceptors.any((i) => i is LogInterceptor), isTrue);
  });

  test('does not add LogInterceptor in prod environment', () {
    EnvConfig.init(AppEnvironment.prod);

    final container = ProviderContainer(overrides: [
      tokenLocalDataSourceProvider.overrideWithValue(_FakeTokenLocalDataSource()),
      tenantProvider.overrideWith((ref) => const Tenant('https://api.test/api')),
    ]);

    final dio = container.read(dioProvider);
    expect(dio.interceptors.any((i) => i is LogInterceptor), isFalse);
  });

  test('throws when tenant not initialized', () {
    EnvConfig.init(AppEnvironment.dev);

    final container = ProviderContainer(overrides: [
      tokenLocalDataSourceProvider.overrideWithValue(_FakeTokenLocalDataSource()),
    ]);

    expect(() => container.read(dioProvider), throwsA(isA<UninitializedTenantException>()));
  });

  test('uses tenant.baseUrl for Dio options', () {
    EnvConfig.init(AppEnvironment.dev);

    final container = ProviderContainer(overrides: [
      tokenLocalDataSourceProvider.overrideWithValue(_FakeTokenLocalDataSource()),
      tenantProvider.overrideWith((ref) => const Tenant('https://example.tenant/api')),
    ]);

    final dio = container.read(dioProvider);
    expect(dio.options.baseUrl, contains('https://example.tenant/api'));
  });

  test('does not retry when request is cancelled', () async {
    EnvConfig.init(AppEnvironment.prod); // prod has maxRetries > 0

    final container = ProviderContainer(overrides: [
      tokenLocalDataSourceProvider.overrideWithValue(_FakeTokenLocalDataSource()),
    ]);

    final dio = container.read(dioProvider);

    final adapter = _CountingAdapter(DioException(
      requestOptions: RequestOptions(path: '/cancel'),
      type: DioExceptionType.cancel,
    ));
    dio.httpClientAdapter = adapter;

    await expectLater(
      () async => await dio.get('/cancel'),
      throwsA(predicate((e) => e is DioException && e.type == DioExceptionType.cancel)),
    );

    // ensure we attempted the request only once (no hidden retries)
    expect(adapter.calls, equals(1));
  });

  test('does not retry non-replayable request bodies', () async {
    EnvConfig.init(AppEnvironment.prod);

    final container = ProviderContainer(overrides: [
      tokenLocalDataSourceProvider.overrideWithValue(_FakeTokenLocalDataSource()),
    ]);

    final dio = container.read(dioProvider);

    final adapter = _CountingAdapter(DioException(
      requestOptions: RequestOptions(path: '/upload', method: 'POST'),
      type: DioExceptionType.connectionError,
    ));
    dio.httpClientAdapter = adapter;

    // stream body (non-replayable) — retry should NOT happen even though the
    // adapter throws a transient error.
    await expectLater(
      () async => await dio.post('/upload', data: Stream.fromIterable([utf8.encode('x')])),
      throwsA(predicate((e) => e is DioException && e.type == DioExceptionType.connectionError)),
    );

    expect(adapter.calls, equals(1));
  });

  test('adds X-Request-Id header and exposes it in extra', () async {
    EnvConfig.init(AppEnvironment.dev);

    final container = ProviderContainer(overrides: [
      tokenLocalDataSourceProvider.overrideWithValue(_FakeTokenLocalDataSource()),
    ]);

    final dio = container.read(dioProvider);
    final adapter = _CaptureAdapter();
    dio.httpClientAdapter = adapter;

    final res = await dio.get('/trace');
    expect(res.statusCode, equals(200));

    final opts = adapter.captured!;
    expect(opts.headers.containsKey('X-Request-Id'), isTrue);
    expect(opts.extra['requestId'], equals(opts.headers['X-Request-Id'].toString()));
    expect(opts.headers['X-Request-Id'].toString().isNotEmpty, isTrue);
  });
}
