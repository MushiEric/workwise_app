class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'NetworkException']);

  @override
  String toString() => 'NetworkException: $message';
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = 'TimeoutException']);

  @override
  String toString() => 'TimeoutException: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'CacheException']);

  @override
  String toString() => 'CacheException: $message';
}
