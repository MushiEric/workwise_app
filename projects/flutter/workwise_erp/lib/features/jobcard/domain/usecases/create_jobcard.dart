import 'package:workwise_erp/core/errors/either.dart';

import '../repositories/jobcard_repository.dart';
import '../entities/jobcard_create_params.dart';

class CreateJobcard {
  final JobcardRepository repository;
  CreateJobcard(this.repository);

  Future<Either<dynamic, int>> call(JobcardCreateParams params) async {
    return repository.createJobcard(params: params);
  }
}
