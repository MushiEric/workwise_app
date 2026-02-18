import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/operator.dart';
import '../repositories/operator_repository.dart';

class GetOperators {
  final OperatorRepository repository;
  GetOperators(this.repository);

  Future<Either<Failure, List<Operator>>> call() async {
    return repository.getOperators();
  }
}
