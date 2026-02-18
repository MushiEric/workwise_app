import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../../domain/entities/operator.dart' as domain;
import '../../domain/repositories/operator_repository.dart';
import '../datasources/operator_remote_data_source.dart';

class OperatorRepositoryImpl implements OperatorRepository {
  final OperatorRemoteDataSource remote;
  OperatorRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<domain.Operator>>> getOperators() async {
    try {
      final models = await remote.getOperators();
      return Either.right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
