import '../entities/device_security_status.dart';

abstract interface class SecurityRepository {
  Future<DeviceSecurityStatus> getDeviceSecurityStatus();
}
