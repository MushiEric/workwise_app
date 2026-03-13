import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_jobcards.dart';

class JobcardState {
  final bool loading;
  final List<dynamic> items;
  final String? error;

  const JobcardState._({required this.loading, required this.items, this.error});
  const JobcardState.initial() : this._(loading: false, items: const []);
  const JobcardState.loading() : this._(loading: true, items: const []);
  const JobcardState.loaded(List<dynamic> items) : this._(loading: false, items: items);
  const JobcardState.error(String message) : this._(loading: false, items: const [], error: message);
}

class JobcardNotifier extends StateNotifier<JobcardState> {
  final GetJobcards getJobcards;

  JobcardNotifier({required this.getJobcards}) : super(const JobcardState.initial());

  Future<void> loadJobcards({int page = 1, int perPage = 500, String? status, bool force = false}) async {
    // avoid concurrent/redundant loads
    if (state.loading) return;
    // skip reload if data is already loaded and caller did not force a refresh
    if (!force && state.items.isNotEmpty && state.error == null) return;
    state = const JobcardState.loading();
    final res = await getJobcards.call(page: page, perPage: perPage, status: status, force: force);
    res.fold(
      (l) => state = JobcardState.error(l is Exception ? l.toString() : '$l'),
      (r) => state = JobcardState.loaded(r),
    );
  }
}
