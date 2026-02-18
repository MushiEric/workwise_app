import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use-case: Get current authenticated user.
/// Returns Either<Failure, User>
class GetCurrentUser {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  Future<Either<Failure, User>> call() async {
    return repository.fetchCurrentUser();
  }
}
