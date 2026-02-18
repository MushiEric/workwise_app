import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';
import '../entities/status.dart';

class GetSupportStatuses {
  final SupportRepository repository;
  GetSupportStatuses(this.repository);

  Future<Either<Failure, List<SupportStatus>>> call() async {
    return repository.getStatuses();
  }
}
