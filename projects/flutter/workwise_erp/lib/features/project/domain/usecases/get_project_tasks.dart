import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/project_task.dart';
import '../repositories/project_repository.dart';

class GetProjectTasks {
  final ProjectRepository repository;
  GetProjectTasks(this.repository);

  Future<Either<Failure, List<ProjectTask>>> call(int projectId) async {
    return repository.getProjectTasks(projectId);
  }
}
