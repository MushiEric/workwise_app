import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/auth_repository.dart';

/// Use-case: logout (clears local token/session)
class Logout {
  final AuthRepository repository;
  Logout(this.repository);

  Future<Either<Failure, void>> call() async {
    return repository.logout();
  }
}
