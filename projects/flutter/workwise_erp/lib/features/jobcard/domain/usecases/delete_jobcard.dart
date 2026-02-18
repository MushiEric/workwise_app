import 'package:workwise_erp/core/errors/either.dart';

import '../repositories/jobcard_repository.dart';

class DeleteJobcard {
  final JobcardRepository repository;
  DeleteJobcard(this.repository);

  Future<Either<dynamic, void>> call({required int id}) async {
    return repository.deleteJobcard(id: id);
  }
}
