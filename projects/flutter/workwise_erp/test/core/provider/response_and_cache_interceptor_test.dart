import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workwise_erp/core/provider/cache_interceptor.dart';
import 'package:workwise_erp/core/provider/response_validation_interceptor.dart';

// Minimal fake HttpClientAdapter implementations to drive Dio responses
class _SuccessAdapter implements HttpClientAdapter {
  final int statusCode;
  final Map<String, List<String>> headers;
  final List<int> bodyBytes;

  _SuccessAdapter({required this.statusCode, required this.headers, required this.bodyBytes});

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<dynamic>? cancelFuture) async {
    return ResponseBody.fromBytes(bodyBytes, statusCode, headers: headers);
  }
}

class _ErrorAdapter implements HttpClientAdapter {
  final DioException exception;
  _ErrorAdapter(this.exception);

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<dynamic>? cancelFuture) async {
    throw exception;
  }
}

void main() {
  const baseUrl = 'https://api.test';
  const cacheKey = 'cache:GET:$baseUrl/foo';
  const cacheKeyBar = 'cache:GET:$baseUrl/bar';

  setUp(() async {
    // clear shared preferences before each test
    SharedPreferences.setMockInitialValues({});
  });

  test('ResponseValidationInterceptor rejects HTML responses and they are not cached', () async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));

    // order: CacheInterceptor added first, ResponseValidationInterceptor added after
    // so validation runs before cache write (onResponse runs in reverse order).
    dio.interceptors.add(CacheInterceptor(ttlSeconds: 60));
    dio.interceptors.add(const ResponseValidationInterceptor());

    // adapter returns HTML (status 200)
    dio.httpClientAdapter = _SuccessAdapter(
      statusCode: 200,
      headers: {'content-type': ['text/html; charset=utf-8']},
      bodyBytes: utf8.encode('<html><body>Unauthorized</body></html>'),
    );

    // Expect the GET to throw a DioException of type badResponse
    await expectLater(
      () async => await dio.get('/foo'),
      throwsA(predicate((e) => e is DioException && e.type == DioExceptionType.badResponse)),
    );

    // Cache should not contain the HTML response
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(cacheKey), isNull);
  });

  test('CacheInterceptor stores JSON responses and serves cached data on network failure', () async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));

    dio.interceptors.add(CacheInterceptor(ttlSeconds: 60));
    dio.interceptors.add(const ResponseValidationInterceptor());

    // first adapter: returns valid JSON
    dio.httpClientAdapter = _SuccessAdapter(
      statusCode: 200,
      headers: {'content-type': ['application/json; charset=utf-8']},
      bodyBytes: utf8.encode(json.encode({'ok': true, 'value': 123})),
    );

    final res1 = await dio.get('/bar');
    expect(res1.data, isA<Map>());
    expect(res1.data['value'], 123);

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(cacheKeyBar);
    expect(cached, isNotNull);

    // now simulate network failure; adapter throws a connection error
    dio.httpClientAdapter = _ErrorAdapter(DioException(
      requestOptions: RequestOptions(path: '/bar', baseUrl: baseUrl),
      type: DioExceptionType.connectionError,
    ));

    final res2 = await dio.get('/bar'); // should be served from cache
    expect(res2.data, isA<Map>());
    expect(res2.data['value'], 123);
  });
}
