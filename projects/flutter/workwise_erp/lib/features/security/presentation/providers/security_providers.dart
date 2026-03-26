import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/environment.dart';
import '../../data/datasources/security_platform_data_source.dart';
import '../../data/repositories/security_repository_impl.dart';
import '../../domain/entities/device_security_status.dart';
import '../../domain/usecases/check_developer_options.dart';

final _securityDataSourceProvider = Provider<SecurityPlatformDataSource>(
  (_) => SecurityPlatformDataSource(),
);

final _securityRepositoryProvider = Provider<SecurityRepositoryImpl>(
  (ref) => SecurityRepositoryImpl(ref.read(_securityDataSourceProvider)),
);

final _checkDeveloperOptionsProvider = Provider<CheckDeveloperOptions>(
  (ref) => CheckDeveloperOptions(ref.read(_securityRepositoryProvider)),
);

/// Resolves once; returns the device security status for the current session.
///
/// In [AppEnvironment.dev] and [AppEnvironment.staging] the check is bypassed entirely so that developers
/// can run the app with Developer Options enabled without being blocked.
final deviceSecurityProvider = FutureProvider<DeviceSecurityStatus>((ref) {
  if (EnvConfig.current.env == AppEnvironment.dev || EnvConfig.current.env == AppEnvironment.staging) {
    return Future.value(
      const DeviceSecurityStatus(isDeveloperOptionsEnabled: false),
    );
  }
  return ref.read(_checkDeveloperOptionsProvider).call();
});
