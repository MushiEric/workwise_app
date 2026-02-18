import 'package:workwise_erp/core/errors/either.dart';

import '../entities/jobcard_detail.dart';
import '../repositories/jobcard_repository.dart';

class GetJobcardById {
  final JobcardRepository repository;
  GetJobcardById(this.repository);

  Future<Either<dynamic, JobcardDetail>> call(int id) {
    return repository.getJobcardById(id);
  }
}
