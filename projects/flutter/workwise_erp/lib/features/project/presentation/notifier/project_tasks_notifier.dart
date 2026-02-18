import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../../domain/usecases/get_project_tasks.dart';
import '../state/project_tasks_state.dart';

class ProjectTasksNotifier extends StateNotifier<ProjectTasksState> {
  final GetProjectTasks getProjectTasks;
  ProjectTasksNotifier({required this.getProjectTasks}) : super(const ProjectTasksState.initial());

  Future<void> loadTasks(int projectId) async {
    state = const ProjectTasksState.loading();
    try {
      final res = await getProjectTasks.call(projectId);
      res.fold((f) => state = ProjectTasksState.error(f.message), (list) => state = ProjectTasksState.loaded(list));
    } catch (e) {
      state = ProjectTasksState.error('Failed to load tasks: ${e.toString()}');
    }
  }
}
