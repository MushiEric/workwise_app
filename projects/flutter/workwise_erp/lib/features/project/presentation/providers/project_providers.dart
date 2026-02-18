import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/project_remote_data_source.dart';
import '../../data/datasources/project_local_data_source.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/usecases/get_projects.dart';
import '../../domain/usecases/get_project_by_id.dart';
import '../../domain/usecases/get_project_tasks.dart';
import '../notifier/project_notifier.dart';
import '../state/project_state.dart';
import '../notifier/project_tasks_notifier.dart';
import '../state/project_tasks_state.dart';

final projectRemoteDataSourceProvider = Provider<ProjectRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProjectRemoteDataSource(dio);
});

final projectLocalDataSourceProvider = Provider((ref) {
  return ProjectLocalDataSource();
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final remote = ref.watch(projectRemoteDataSourceProvider);
  final local = ref.watch(projectLocalDataSourceProvider);
  return ProjectRepositoryImpl(remote, local);
});

final getProjectsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetProjects(repo);
});

final getProjectByIdUseCaseProvider = Provider((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetProjectById(repo);
});

final projectNotifierProvider = StateNotifierProvider<ProjectNotifier, ProjectState>((ref) {
  final getProjects = ref.watch(getProjectsUseCaseProvider);
  final getProjectById = ref.watch(getProjectByIdUseCaseProvider);
  return ProjectNotifier(getProjects: getProjects, getProjectById: getProjectById);
});

final getProjectTasksUseCaseProvider = Provider((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetProjectTasks(repo);
});

final projectTasksNotifierProvider = StateNotifierProvider<ProjectTasksNotifier, ProjectTasksState>((ref) {
  final getTasks = ref.watch(getProjectTasksUseCaseProvider);
  return ProjectTasksNotifier(getProjectTasks: getTasks);
});