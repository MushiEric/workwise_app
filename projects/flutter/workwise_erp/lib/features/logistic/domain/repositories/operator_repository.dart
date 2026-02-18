import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/operator.dart';

abstract class OperatorRepository {
  Future<Either<Failure, List<Operator>>> getOperators();
}
