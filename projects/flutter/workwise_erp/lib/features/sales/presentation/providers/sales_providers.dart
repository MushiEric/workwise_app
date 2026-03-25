import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/sales_remote_data_source.dart';
import '../../data/models/sales_settings_model.dart';
import '../../data/repositories/sales_repository_impl.dart';
import '../../domain/entities/sales_settings.dart';
import '../../domain/repositories/sales_repository.dart';
import '../../domain/usecases/get_recent_orders.dart';

// Entities
// import '../../domain/entities/order_status.dart';
import '../../domain/entities/product_summary.dart';
import '../../domain/entities/package_unit.dart';

// Models (for .toDomain() extensions)
// import '../../data/models/order_status_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/package_unit_model.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../notifier/sales_notifier.dart';
import '../state/sales_state.dart';

final salesRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return SalesRemoteDataSource(dio);
});

final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  final remote = ref.watch(salesRemoteDataSourceProvider);
  return SalesRepositoryImpl(remote);
});

final getRecentOrdersUseCaseProvider = Provider((ref) {
  final repo = ref.watch(salesRepositoryProvider);
  return GetRecentOrders(repo);
});

final salesNotifierProvider = StateNotifierProvider<SalesNotifier, SalesState>((
  ref,
) {
  final getRecentOrders = ref.watch(getRecentOrdersUseCaseProvider);
  return SalesNotifier(getRecentOrders: getRecentOrders);
});

/// Typed sales settings fetched from /sales/getSalesSettings.
/// Use this for business logic (validation, payload building, etc.).
final salesSettingsProvider = FutureProvider<SalesSettings>((ref) async {
  final remote = ref.watch(salesRemoteDataSourceProvider);
  try {
    final raw = await remote.getSalesSettings();
    return SalesSettingsModel.fromJson(raw);
  } catch (_) {
    return SalesSettings.defaults;
  }
});

/// Alias-expanded settings map used by the order-create form's `_fieldEnabled()`
/// helper. The map contains both the original API keys (e.g. `order_show_title`)
/// and the form's expected keys (e.g. `enable_title`, `show_title`) so field
/// visibility works correctly without modifying every widget call in the form.
final salesSettingsConfigProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final remote = ref.watch(salesRemoteDataSourceProvider);
  try {
    final raw = await remote.getSalesSettings();
    return SalesSettingsModel.toFormConfig(raw);
  } catch (_) {
    return <String, dynamic>{};
  }
});

/// Available order statuses for the Status dropdown.
final salesOrderStatusesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final remote = ref.watch(salesRemoteDataSourceProvider);
  try {
    return await remote.getOrderStatuses().then(
      (l) => l.map((m) => m.toJson()).toList(),
    );
  } catch (_) {
    return [];
  }
});

/// Available products/items for the Items section.
final salesProductsProvider = FutureProvider<List<ProductSummary>>((ref) async {
  final auth = ref.watch(authNotifierProvider);
  final creatorId = auth.maybeWhen(
    authenticated: (u) => u.id,
    orElse: () => null,
  );
  final remote = ref.watch(salesRemoteDataSourceProvider);
  try {
    final rawList = await remote.getRawProducts(creatorId: creatorId);
    return rawList.map((m) => ProductModel.fromJson(m).toDomain()).toList();
  } catch (e) {
    // ignore: avoid_print
    print('[SalesProducts] Error: $e');
    return [];
  }
});

/// Available package/measurement units for the Items section.
final salesPackageUnitsProvider = FutureProvider<List<PackageUnit>>((
  ref,
) async {
  final auth = ref.watch(authNotifierProvider);
  final creatorId = auth.maybeWhen(
    authenticated: (u) => u.id,
    orElse: () => null,
  );
  final remote = ref.watch(salesRemoteDataSourceProvider);
  try {
    final models = await remote.getPackageUnits(creatorId: creatorId);
    return models.map((m) => m.toDomain()).toList();
  } catch (e) {
    // ignore: avoid_print
    print('[SalesUnits] Error: $e');
    return [];
  }
});

/// Available vehicles for the Truck List section.
final salesVehiclesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final remote = ref.watch(salesRemoteDataSourceProvider);
  try {
    return await remote.getVehicles();
  } catch (_) {
    return [];
  }
});

final salesPackageTypesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return await ref.watch(salesRemoteDataSourceProvider).getPackageTypes();
});

final salesWarehousesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return await ref.watch(salesRemoteDataSourceProvider).getWarehouses();
});

final salesQuotationsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return await ref.watch(salesRemoteDataSourceProvider).getQuotations();
});

final salesContractsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return await ref.watch(salesRemoteDataSourceProvider).getContracts();
});

final salesRequestsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return await ref.watch(salesRemoteDataSourceProvider).getRequests();
});

final salesTaxesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return await ref.watch(salesRemoteDataSourceProvider).getTaxes();
});

final salesCurrenciesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return await ref.watch(salesRemoteDataSourceProvider).getCurrencies();
});

final salesUsersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return await ref.watch(salesRemoteDataSourceProvider).getUsers();
});
