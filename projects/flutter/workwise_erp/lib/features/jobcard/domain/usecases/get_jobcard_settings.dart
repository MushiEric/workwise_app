import 'package:workwise_erp/core/errors/either.dart';

import '../entities/jobcard_status.dart';
import '../repositories/jobcard_repository.dart';

class GetJobcardSettings {
  final JobcardRepository repository;
  GetJobcardSettings(this.repository);

  Future<Either<dynamic, List<JobcardStatus>>> call() {
    return repository.getSettings();
  }
}
