import '../../domain/entities/device_security_status.dart';
import '../../domain/repositories/security_repository.dart';
import '../datasources/security_platform_data_source.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  final SecurityPlatformDataSource _dataSource;

  const SecurityRepositoryImpl(this._dataSource);

  @override
  Future<DeviceSecurityStatus> getDeviceSecurityStatus() async {
    final devOptionsEnabled = await _dataSource.isDeveloperOptionsEnabled();
    return DeviceSecurityStatus(isDeveloperOptionsEnabled: devOptionsEnabled);
  }
}
