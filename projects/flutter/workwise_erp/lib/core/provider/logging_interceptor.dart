import 'package:dio/dio.dart';

/// Factory for a configured `LogInterceptor` used across the app.
///
/// `logger` is a callback used to capture logs (defaults to `print`). Tests can
/// inject a custom logger to assert log calls.
LogInterceptor createLoggingInterceptor({void Function(Object?)? logger}) {
  return LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    error: true,
    logPrint: logger ?? (obj) => // ignore: avoid_print
        print('[DIO] $obj'),
  );
}
