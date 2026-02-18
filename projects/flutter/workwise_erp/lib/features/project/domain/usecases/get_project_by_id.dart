import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjectById {
  final ProjectRepository repository;
  GetProjectById(this.repository);

  Future<Either<Failure, Project>> call(int id) async {
    return repository.getProjectById(id);
  }
}
