class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'ServerException']);

  @override
  String toString() => 'ServerException: $message';
}
