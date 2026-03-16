import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/auth_repository.dart';

class ForgotPasswordParams {
  final String emailOrPhone;
  final String? redirectUrl;
  ForgotPasswordParams({required this.emailOrPhone, this.redirectUrl});
}

class ForgotPassword {
  final AuthRepository repository;
  ForgotPassword(this.repository);

  /// Returns the backend message (e.g. "Password reset initiated..."), or a
  /// generic success message if none is returned.
  Future<Either<Failure, String>> call(ForgotPasswordParams params) async {
    return repository.forgotPassword(emailOrPhone: params.emailOrPhone);
  }
}
