import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_jobcards.dart';

class JobcardState {
  final bool loading;
  final List<dynamic> items;
  final String? error;
  final int totalItems;

  const JobcardState._({
    required this.loading,
    required this.items,
    this.error,
    this.totalItems = 0,
  });

  const JobcardState.initial()
      : this._(loading: false, items: const []);

  const JobcardState.loading()
      : this._(loading: true, items: const []);

  JobcardState copyWith({
    bool? loading,
    List<dynamic>? items,
    String? error,
    int? totalItems,
  }) {
    return JobcardState._(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: error ?? this.error,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class JobcardNotifier extends StateNotifier<JobcardState> {
  final GetJobcards getJobcards;

  JobcardNotifier({required this.getJobcards})
      : super(const JobcardState.initial());

  Future<void> loadJobcards({
    int perPage = 5000,
    String? status,
    bool force = false,
  }) async {
    if (state.loading) return;
    if (!force && state.items.isNotEmpty && state.error == null) return;

    state = const JobcardState.loading();
    final res = await getJobcards.call(
      page: 1,
      perPage: perPage,
      status: status,
      force: force,
    );

    res.fold(
      (l) => state = JobcardState._(
        loading: false,
        items: const [],
        error: l is Exception ? l.toString() : '$l',
      ),
      (r) => state = JobcardState._(
        loading: false,
        items: r.items,
        totalItems: r.total,
      ),
    );
  }

  // Simplified: loadMore is no longer needed since we fetch all at once, 
  // but kept as a no-op to avoid breaking UI calls until refactored.
  Future<void> loadMore() async {}
}
