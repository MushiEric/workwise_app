import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomers {
  final CustomerRepository repository;
  GetCustomers(this.repository);

  Future<Either<Failure, List<Customer>>> call() => repository.getCustomers();
}
