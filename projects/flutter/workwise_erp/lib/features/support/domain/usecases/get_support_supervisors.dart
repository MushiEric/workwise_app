import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';
import '../entities/support_supervisor.dart';

class GetSupportSupervisors {
  final SupportRepository repository;
  GetSupportSupervisors(this.repository);

  Future<Either<Failure, List<SupportSupervisor>>> call() async {
    return repository.getSupervisors();
  }
}
