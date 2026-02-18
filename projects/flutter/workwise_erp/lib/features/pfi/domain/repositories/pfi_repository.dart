import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/pfi.dart';

abstract class PfiRepository {
  Future<Either<Failure, List<Pfi>>> getPfis();
}
