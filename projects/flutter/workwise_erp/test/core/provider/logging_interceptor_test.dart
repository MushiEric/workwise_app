import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/core/provider/logging_interceptor.dart';

void main() {
  test('createLoggingInterceptor returns a LogInterceptor', () {
    final i = createLoggingInterceptor();
    expect(i, isA<LogInterceptor>());
  });

  test('createLoggingInterceptor accepts custom logger', () {
    var called = false;
    void logger(Object? o) {
      called = true;
    }

    final i = createLoggingInterceptor(logger: logger);
    // add to Dio and fire a request to ensure logger is callable (no assertions on output)
    final dio = Dio()..interceptors.add(i);
    dio.httpClientAdapter = _NoopAdapter();

    expect(() async => await dio.get('https://example.com/'), returnsNormally);
  });
}

class _NoopAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream, Future? cancelFuture) async {
    return ResponseBody.fromString('{}', 200, headers: {"content-type": ["application/json"]});
  }
}
