import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/project.dart';
import '../entities/project_task.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<Project>>> getProjects();

  /// Returns cached projects if available (null when no cache or expired).
  Future<List<Project>?> getCachedProjects();

  Future<Either<Failure, Project>> getProjectById(int id);

  /// Tasks for a specific project
  Future<Either<Failure, List<ProjectTask>>> getProjectTasks(int projectId);
}
