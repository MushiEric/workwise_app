import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_jobcard_by_id.dart';

class JobcardDetailState {
  final bool loading;
  final dynamic item;
  final String? error;

  const JobcardDetailState._({required this.loading, this.item, this.error});
  const JobcardDetailState.initial() : this._(loading: false, item: null);
  const JobcardDetailState.loading() : this._(loading: true);
  const JobcardDetailState.loaded(dynamic item) : this._(loading: false, item: item);
  const JobcardDetailState.error(String message) : this._(loading: false, item: null, error: message);
}

class JobcardDetailNotifier extends StateNotifier<JobcardDetailState> {
  final GetJobcardById getJobcardById;
  JobcardDetailNotifier({required this.getJobcardById}) : super(const JobcardDetailState.initial());

  Future<void> load(int id) async {
    state = const JobcardDetailState.loading();
    final res = await getJobcardById.call(id);
    res.fold((l) => state = JobcardDetailState.error(l is Exception ? l.toString() : '$l'), (r) => state = JobcardDetailState.loaded(r));
  }
}
