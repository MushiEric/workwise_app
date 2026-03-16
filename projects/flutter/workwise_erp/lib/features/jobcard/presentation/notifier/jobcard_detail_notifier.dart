import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/jobcard_repository.dart';
import '../../domain/usecases/get_jobcard_by_id.dart';

class JobcardDetailState {
  final bool loading;
  final dynamic item;
  final String? error;
  final bool statusChanging;

  const JobcardDetailState._({
    required this.loading,
    this.item,
    this.error,
    this.statusChanging = false,
  });
  const JobcardDetailState.initial() : this._(loading: false, item: null);
  const JobcardDetailState.loading() : this._(loading: true);
  const JobcardDetailState.loaded(dynamic item)
    : this._(loading: false, item: item);
  const JobcardDetailState.error(String message)
    : this._(loading: false, item: null, error: message);

  JobcardDetailState copyWith({
    bool? statusChanging,
    dynamic item,
    String? error,
  }) {
    return JobcardDetailState._(
      loading: loading,
      item: item ?? this.item,
      error: error ?? this.error,
      statusChanging: statusChanging ?? this.statusChanging,
    );
  }
}

class JobcardDetailNotifier extends StateNotifier<JobcardDetailState> {
  final GetJobcardById getJobcardById;
  final JobcardRepository repository;

  JobcardDetailNotifier({
    required this.getJobcardById,
    required this.repository,
  }) : super(const JobcardDetailState.initial());

  Future<void> load(int id) async {
    state = const JobcardDetailState.loading();
    final res = await getJobcardById.call(id);
    res.fold(
      (l) => state = JobcardDetailState.error(
        l is Exception ? l.toString() : '$l',
      ),
      (r) => state = JobcardDetailState.loaded(r),
    );
  }

  Future<String?> changeStatus(int id, int newStatus) async {
    state = state.copyWith(statusChanging: true);
    final res = await repository.changeJobcardStatus(id: id, status: newStatus);
    return res.fold(
      (l) {
        state = state.copyWith(statusChanging: false);
        return l.toString();
      },
      (_) async {
        await load(id);
        return null;
      },
    );
  }
}
