import 'package:workwise_erp/core/errors/either.dart';

import '../entities/jobcard_create_params.dart';
import '../entities/jobcard_create_response.dart';
import '../repositories/jobcard_repository.dart';

class CreateJobcard {
  final JobcardRepository repository;
  CreateJobcard(this.repository);

  Future<Either<dynamic, JobcardCreateResponse>> call(
    JobcardCreateParams params,
  ) async {
    return repository.createJobcard(params: params);
  }
}
