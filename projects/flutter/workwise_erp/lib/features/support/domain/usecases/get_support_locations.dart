import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';
import '../entities/support_location.dart';

class GetSupportLocations {
  final SupportRepository repository;
  GetSupportLocations(this.repository);

  Future<Either<Failure, List<SupportLocation>>> call() async {
    return repository.getLocations();
  }
}
