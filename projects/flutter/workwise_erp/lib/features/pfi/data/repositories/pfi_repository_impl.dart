import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../../domain/entities/pfi.dart' as domain;
import '../../domain/repositories/pfi_repository.dart';
import '../datasources/pfi_remote_data_source.dart';

class PfiRepositoryImpl implements PfiRepository {
  final PfiRemoteDataSource remote;
  PfiRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<domain.Pfi>>> getPfis() async {
    try {
      final models = await remote.getPfis();
      return Either.right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
