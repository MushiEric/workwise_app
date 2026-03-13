import 'package:workwise_erp/core/errors/either.dart';
import '../repositories/jobcard_repository.dart';

class RejectJobcard {
  final JobcardRepository repository;
  RejectJobcard(this.repository);

  Future<Either<dynamic, void>> call(int jobcardId, {String? reason}) {
    return repository.rejectJobcard(jobcardId, reason: reason);
  }
}
