import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/pfi_repository.dart';
import '../entities/pfi.dart';

class GetPfis {
  final PfiRepository repository;
  GetPfis(this.repository);

  Future<Either<Failure, List<Pfi>>> call() async {
    return repository.getPfis();
  }
}
