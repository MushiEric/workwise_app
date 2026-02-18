import 'package:workwise_erp/core/errors/either.dart';

import '../repositories/jobcard_repository.dart';

class GetJobcardConfig {
  final JobcardRepository repository;
  GetJobcardConfig(this.repository);

  Future<Either<dynamic, Map<String, dynamic>>> call() {
    return repository.getConfig();
  }
}
