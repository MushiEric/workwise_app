import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/sales_remote_data_source.dart';
import '../../data/repositories/sales_repository_impl.dart';
import '../../domain/repositories/sales_repository.dart';
import '../../domain/usecases/get_recent_orders.dart';

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
