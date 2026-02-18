import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/project_task.dart';

part 'project_tasks_state.freezed.dart';

@freezed
class ProjectTasksState with _$ProjectTasksState {
  const factory ProjectTasksState.initial() = _Initial;
  const factory ProjectTasksState.loading() = _Loading;
  const factory ProjectTasksState.loaded(List<ProjectTask> tasks) = _Loaded;
  const factory ProjectTasksState.error(String message) = _Error;
}
