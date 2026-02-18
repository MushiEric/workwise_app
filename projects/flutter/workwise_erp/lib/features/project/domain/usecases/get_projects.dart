import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjects {
  final ProjectRepository repository;
  GetProjects(this.repository);

  Future<Either<Failure, List<Project>>> call() async {
    return repository.getProjects();
  }
}
