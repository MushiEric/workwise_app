import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_assets.dart';
import '../state/assets_state.dart';

class AssetsNotifier extends StateNotifier<AssetsState> {
  final GetAssets getAssets;
  AssetsNotifier({required this.getAssets}) : super(const AssetsState.initial());

  Future<void> loadAssets() async {
    state = const AssetsState.loading();
    final res = await getAssets.call();
    res.fold((f) => state = AssetsState.error(f.message), (list) => state = AssetsState.loaded(list));
  }
}
