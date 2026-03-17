import 'package:workwise_erp/core/errors/either.dart';
import '../repositories/jobcard_repository.dart';

class ApproveJobcard {
  final JobcardRepository repository;
  ApproveJobcard(this.repository);

  Future<Either<dynamic, void>> call({
    required int jobcardId,
    required int status,
    required int approvalId,
    required int roleUserId,
    String? comment,
  }) {
    return repository.approveJobcard(
      jobcardId,
      status: status,
      approvalId: approvalId,
      roleUserId: roleUserId,
      comment: comment,
    );
  }
}
