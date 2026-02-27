import 'package:workwise_erp/core/errors/either.dart';
import '../entities/jobcard_form_data.dart';
import '../repositories/jobcard_repository.dart';

/// Fetches all dropdown/catalog data (vehicles, users, products, product units)
/// required to render the jobcard creation form in a single round trip.
class GetJobcardFormData {
  final JobcardRepository repository;
  GetJobcardFormData(this.repository);

  Future<Either<dynamic, JobcardFormData>> call({int? creatorId}) {
    return repository.getFormData(creatorId: creatorId);
  }
}
