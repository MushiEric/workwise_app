import 'package:workwise_erp/core/errors/either.dart';

import '../repositories/jobcard_repository.dart';

class GenerateJobcardNumber {
  final JobcardRepository repository;
  GenerateJobcardNumber(this.repository);

  Future<Either<dynamic, String>> call() async {
    return repository.generateUniqueNumber();
  }
}
