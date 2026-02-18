import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../../domain/entities/project.dart' as domain;
import '../../domain/entities/project_task.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';
import '../datasources/project_local_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remote;
  final ProjectLocalDataSource local;

  ProjectRepositoryImpl(this.remote, this.local);

  @override
  Future<Either<Failure, List<domain.Project>>> getProjects() async {
    try {
      final models = await remote.getProjects();

      // update local cache (best-effort)
      try {
        await local.cacheProjects(models);
      } catch (_) {}

      return Either.right(models.map((m) => m as domain.Project).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<List<domain.Project>?> getCachedProjects() async {
    final cached = await local.getCachedProjects();
    if (cached == null) return null;
    return cached.map((m) => m as domain.Project).toList();
  }

  @override
  Future<Either<Failure, domain.Project>> getProjectById(int id) async {
    try {
      final model = await remote.getProjectById(id);
      return Either.right(model);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectTask>>> getProjectTasks(int projectId) async {
    try {
      final models = await remote.getProjectTasks(projectId);
      return Either.right(models.map((m) => m as ProjectTask).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
