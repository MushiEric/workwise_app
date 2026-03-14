import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/models/paginated_response.dart';

import '../entities/jobcard.dart';
import '../repositories/jobcard_repository.dart';

class GetJobcards {
  final JobcardRepository repository;
  GetJobcards(this.repository);

  Future<Either<dynamic, PaginatedResponse<Jobcard>>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    bool force = false,
  }) {
    return repository.getJobcards(
      page: page,
      perPage: perPage,
      status: status,
      force: force,
    );
  }
}
