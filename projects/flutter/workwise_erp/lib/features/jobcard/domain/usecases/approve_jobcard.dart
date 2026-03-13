import 'package:workwise_erp/core/errors/either.dart';
import '../repositories/jobcard_repository.dart';

class ApproveJobcard {
  final JobcardRepository repository;
  ApproveJobcard(this.repository);

  Future<Either<dynamic, void>> call(int jobcardId) {
    return repository.approveJobcard(jobcardId);
  }
}
