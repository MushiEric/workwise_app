import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_operators.dart';
import '../state/operators_state.dart';

class OperatorsNotifier extends StateNotifier<OperatorsState> {
  final GetOperators getOperators;
  OperatorsNotifier({required this.getOperators}) : super(const OperatorsState.initial());

  Future<void> loadOperators() async {
    state = const OperatorsState.loading();
    final res = await getOperators.call();
    res.fold((f) => state = OperatorsState.error(f.message), (list) => state = OperatorsState.loaded(list));
  }
}
