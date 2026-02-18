import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../../domain/entities/project.dart';
import '../../domain/usecases/get_projects.dart';
import '../../domain/usecases/get_project_by_id.dart';
import '../state/project_state.dart';

class ProjectNotifier extends StateNotifier<ProjectState> {
  final GetProjects getProjects;
  final GetProjectById getProjectById;

  ProjectNotifier({required this.getProjects, required this.getProjectById})
    : super(const ProjectState.initial());

  Future<void> loadProjects() async {
    // 1) try fast cache-first read (shows immediately if available)
    try {
      final cached = await getProjects.repository.getCachedProjects();
      if (cached != null && cached.isNotEmpty) {
        state = ProjectState.loaded(cached);
      } else {
        state = const ProjectState.loading();
      }
    } catch (_) {
      state = const ProjectState.loading();
    }

    // 2) fetch fresh data from network and update cache/state
    final res = await getProjects.call();
    res.fold((f) {
      // only surface error if we don't already have cached data
      final hasLoaded = state.maybeWhen(
        loaded: (_) => true,
        orElse: () => false,
      );
      if (!hasLoaded) state = ProjectState.error(_friendlyMessageForFailure(f));
    }, (list) => state = ProjectState.loaded(list));
  }

  Future<void> loadProjectDetail(int id) async {
    state = const ProjectState.loading();
    try {
      final res = await getProjectById.call(id);
      res.fold(
        (f) => state = ProjectState.error(_friendlyMessageForFailure(f)),
        (p) => state = ProjectState.detail(p),
      );
    } catch (e) {
      state = ProjectState.error('Failed to load project: ${e.toString()}');
    }
  }

  /// Set project detail directly from an existing Project instance (e.g. passed from list)
  void setProjectDetailFromList(Project p) {
    state = ProjectState.detail(p);
  }

  String _friendlyMessageForFailure(Failure f) {
    return f.message;
  }
}
