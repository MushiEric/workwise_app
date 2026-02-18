import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';
import '../entities/support_department.dart';

class GetSupportDepartments {
  final SupportRepository repository;
  GetSupportDepartments(this.repository);

  Future<Either<Failure, List<SupportDepartment>>> call() async {
    return repository.getDepartments();
  }
}
