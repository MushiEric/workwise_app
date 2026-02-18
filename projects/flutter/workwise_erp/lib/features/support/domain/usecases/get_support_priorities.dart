import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';
import '../entities/priority.dart';

class GetSupportPriorities {
  final SupportRepository repository;
  GetSupportPriorities(this.repository);

  Future<Either<Failure, List<Priority>>> call() async {
    return repository.getPriorities();
  }
}
