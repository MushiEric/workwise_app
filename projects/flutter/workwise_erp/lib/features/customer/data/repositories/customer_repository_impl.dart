import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../../domain/entities/customer.dart' as domain;
import '../../domain/entities/customer_contact.dart' as domain;
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remote;
  CustomerRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<domain.Customer>>> getCustomers() async {
    try {
      final models = await remote.getCustomers();
      return Either.right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<domain.CustomerContact>>> getCustomerContacts(
      int customerId) async {
    try {
      final models = await remote.getCustomerContacts(customerId);
      return Either.right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
