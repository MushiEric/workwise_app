import 'package:workwise_erp/core/errors/either.dart';
import '../repositories/jobcard_repository.dart';

class CheckApprovalEligibility {
  final JobcardRepository repository;
  CheckApprovalEligibility(this.repository);

  Future<Either<dynamic, Map<String, dynamic>>> call(int jobcardId) {
    return repository.checkApprovalEligibility(jobcardId);
  }
}
