import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_pfis.dart';
import '../state/pfi_state.dart';

class PfiNotifier extends StateNotifier<PfiState> {
  final GetPfis getPfis;
  PfiNotifier({required this.getPfis}) : super(PfiState.initial());

  Future<void> loadPfis() async {
    state = PfiState.loading(state.pfis);
    final res = await getPfis.call();
    res.fold((f) => state = PfiState.errorState(f.message, state.pfis), (list) => state = PfiState.loaded(list));
  }
}
