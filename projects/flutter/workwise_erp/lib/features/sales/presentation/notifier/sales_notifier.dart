import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_recent_orders.dart';
import '../state/sales_state.dart';

class SalesNotifier extends StateNotifier<SalesState> {
  final GetRecentOrders getRecentOrders;
  SalesNotifier({required this.getRecentOrders})
    : super(const SalesState.initial());

  int _currentOffset = 0;
  Map<String, dynamic>? _lastParams;
  static const int _pageSize = 1000;

  Future<void> loadOrders([Map<String, dynamic>? params]) async {
    state = const SalesState.loading();
    _currentOffset = 0;
    _lastParams = params;

    final queryParams = params != null ? Map<String, dynamic>.from(params) : <String, dynamic>{};
    queryParams.putIfAbsent('start', () => '0');
    queryParams.putIfAbsent('length', () => _pageSize.toString());

    final res = await getRecentOrders.call(queryParams);
    res.fold(
      (failure) => state = SalesState.error(failure.message),
      (list) {
        final hasMore = list.length >= _pageSize;
        _currentOffset = list.length;
        state = SalesState.loaded(list, hasMore: hasMore);
      },
    );
  }

  Future<void> loadMoreOrders() async {
    final current = state.maybeWhen(
      loaded: (orders, isLoadingMore, hasMore) => (orders, isLoadingMore, hasMore),
      orElse: () => (null, false, false),
    );
    final orders = current.$1;
    final isLoadingMore = current.$2;
    final hasMore = current.$3;

    if (orders == null || !hasMore || isLoadingMore) return;

    // Emit loading more state
    state = SalesState.loaded(orders, isLoadingMore: true, hasMore: hasMore);

    final params = _lastParams != null ? Map<String, dynamic>.from(_lastParams!) : <String, dynamic>{};
    params['start'] = _currentOffset.toString();
    params['length'] = _pageSize.toString();

    final res = await getRecentOrders.call(params);
    res.fold(
      (failure) {
        state = SalesState.loaded(orders, isLoadingMore: false, hasMore: hasMore);
      },
      (newOrders) {
        if (newOrders.isEmpty) {
          state = SalesState.loaded(orders, isLoadingMore: false, hasMore: false);
        } else {
          final nextHasMore = newOrders.length >= _pageSize;
          _currentOffset += newOrders.length;
          state = SalesState.loaded([...orders, ...newOrders], isLoadingMore: false, hasMore: nextHasMore);
        }
      },
    );
  }
}
