import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tenant.dart';
import '../storage/tenant_local_data_source.dart';

final _tenantLocalDataSourceProvider = Provider<TenantLocalDataSource>((ref) {
  return TenantLocalDataSource();
});

final tenantLocalDataSourceProvider = Provider<TenantLocalDataSource>((ref) => ref.read(_tenantLocalDataSourceProvider));

/// Holds the active tenant (null = not set)
final tenantProvider = StateProvider<Tenant?>((ref) => null);
