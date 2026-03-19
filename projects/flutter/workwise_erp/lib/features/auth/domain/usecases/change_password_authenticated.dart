import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/auth_repository.dart';

class ChangePasswordAuthenticatedParams {
  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  ChangePasswordAuthenticatedParams({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });
}

class ChangePasswordAuthenticated {
  final AuthRepository repository;

  ChangePasswordAuthenticated(this.repository);

  Future<Either<Failure, void>> call(
    ChangePasswordAuthenticatedParams params,
  ) async {
    return repository.changePasswordAuthenticated(
      currentPassword: params.currentPassword,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}
