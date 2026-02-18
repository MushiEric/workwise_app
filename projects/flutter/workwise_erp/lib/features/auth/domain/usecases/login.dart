import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}

class Login {
  final AuthRepository repository;
  Login(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) async {
    return repository.login(email: params.email, password: params.password);
  }
}
