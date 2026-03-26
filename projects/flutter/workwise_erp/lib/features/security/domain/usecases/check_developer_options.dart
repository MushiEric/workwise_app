import '../entities/device_security_status.dart';
import '../repositories/security_repository.dart';

/// Returns [DeviceSecurityStatus] with [isDeveloperOptionsEnabled] set.
/// Callers should block access to the app when [isDeveloperOptionsEnabled] is true.
class CheckDeveloperOptions {
  final SecurityRepository _repository;

  const CheckDeveloperOptions(this._repository);

  Future<DeviceSecurityStatus> call() => _repository.getDeviceSecurityStatus();
}
