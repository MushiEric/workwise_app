import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'ServerException']);

  @override
  String toString() => 'ServerException: $message';
}

class UninitializedTenantException implements Exception {
  final String message;
  UninitializedTenantException([this.message = 'Tenant is not initialized']);

  @override
  String toString() => 'UninitializedTenantException: $message';
}

/// Converts a [DioException] to a short, user-friendly English message.
/// Never exposes raw stack traces, internal URLs or Dio internals.
String friendlyDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Server is taking too long to respond. Please try again.';
    case DioExceptionType.connectionError:
      return 'No internet connection. Please check your network and try again.';
    case DioExceptionType.cancel:
      return 'Request was cancelled. Please try again.';
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode ?? 0;
      if (status == 401 || status == 403) {
        return 'You are not authorised to perform this action.';
      }
      if (status == 404) return 'The requested resource was not found.';
      if (status >= 500) return 'Server error. Please try again later.';
      return 'Unexpected server response. Please try again.';
    case DioExceptionType.unknown:
    default:
      // Detect network-related OS messages without exposing them verbatim
      final msg = e.message?.toLowerCase() ?? '';
      if (msg.contains('socket') ||
          msg.contains('network') ||
          msg.contains('connection') ||
          msg.contains('internet') ||
          msg.contains('host lookup') ||
          msg.contains('failed host')) {
        return 'No internet connection. Please check your network and try again.';
      }
      return 'Something went wrong. Please try again.';
  }
}
