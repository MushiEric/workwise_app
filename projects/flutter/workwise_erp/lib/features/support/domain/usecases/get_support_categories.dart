import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';
import '../entities/support_category.dart';

class GetSupportCategories {
  final SupportRepository repository;
  GetSupportCategories(this.repository);

  Future<Either<Failure, List<SupportCategory>>> call() async {
    return repository.getCategories();
  }
}
