import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_customers.dart';
import '../state/customers_state.dart';

class CustomersNotifier extends StateNotifier<CustomersState> {
  final GetCustomers _getCustomers;
  CustomersNotifier({required GetCustomers getCustomers})
      : _getCustomers = getCustomers,
        super(const CustomersState.initial());

  Future<void> loadCustomers() async {
    state = const CustomersState.loading();
    final res = await _getCustomers.call();
    res.fold(
      (f) => state = CustomersState.error(f.message),
      (list) => state = CustomersState.loaded(list),
    );
  }
}
