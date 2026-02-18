import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_recent_orders.dart';
import '../state/sales_state.dart';

class SalesNotifier extends StateNotifier<SalesState> {
  final GetRecentOrders getRecentOrders;
  SalesNotifier({required this.getRecentOrders})
    : super(const SalesState.initial());

  Future<void> loadOrders() async {
    state = const SalesState.loading();
    final res = await getRecentOrders.call();
    res.fold(
      (failure) => state = SalesState.error(failure.message),
      (list) => state = SalesState.loaded(list),
    );
  }
}
