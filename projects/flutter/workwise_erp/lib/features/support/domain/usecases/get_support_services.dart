import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';
import '../entities/support_service.dart';

class GetSupportServices {
  final SupportRepository repository;
  GetSupportServices(this.repository);

  Future<Either<Failure, List<SupportService>>> call() async {
    return repository.getServices();
  }
}
