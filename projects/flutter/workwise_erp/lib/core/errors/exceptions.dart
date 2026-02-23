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
