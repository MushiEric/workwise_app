import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_jobcards.dart';

class JobcardState {
  final bool loading;
  final bool loadingMore;
  final List<dynamic> items;
  final String? error;
  final int totalItems;
  final int currentPage;
  final int lastPage;

  const JobcardState._({
    required this.loading,
    this.loadingMore = false,
    required this.items,
    this.error,
    this.totalItems = 0,
    this.currentPage = 1,
    this.lastPage = 1,
  });

  const JobcardState.initial()
      : this._(loading: false, items: const []);

  const JobcardState.loading()
      : this._(loading: true, items: const []);

  JobcardState copyWith({
    bool? loading,
    bool? loadingMore,
    List<dynamic>? items,
    String? error,
    int? totalItems,
    int? currentPage,
    int? lastPage,
  }) {
    return JobcardState._(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      items: items ?? this.items,
      error: error ?? this.error,
      totalItems: totalItems ?? this.totalItems,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
    );
  }

  bool get hasMore => currentPage < lastPage;
}

class JobcardNotifier extends StateNotifier<JobcardState> {
  final GetJobcards getJobcards;

  JobcardNotifier({required this.getJobcards})
      : super(const JobcardState.initial());

  Future<void> loadJobcards({
    int perPage = 100,
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
        currentPage: r.currentPage,
        lastPage: r.lastPage,
      ),
    );
  }

  Future<void> loadMore({int perPage = 100, String? status}) async {
    if (state.loading || state.loadingMore || !state.hasMore) return;

    state = state.copyWith(loadingMore: true);
    final nextPage = state.currentPage + 1;

    final res = await getJobcards.call(
      page: nextPage,
      perPage: perPage,
      status: status,
    );

    res.fold(
      (l) => state = state.copyWith(loadingMore: false, error: '$l'),
      (r) => state = state.copyWith(
        loadingMore: false,
        items: [...state.items, ...r.items],
        totalItems: r.total,
        currentPage: r.currentPage,
        lastPage: r.lastPage,
      ),
    );
  }
}
