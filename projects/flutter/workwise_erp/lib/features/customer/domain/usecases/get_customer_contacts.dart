import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/customer_contact.dart';
import '../repositories/customer_repository.dart';

class GetCustomerContacts {
  final CustomerRepository repository;
  GetCustomerContacts(this.repository);

  Future<Either<Failure, List<CustomerContact>>> call(int customerId) =>
      repository.getCustomerContacts(customerId);
}
