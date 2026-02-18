import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/auth_repository.dart';

class VerifyForgotPasswordOtpParams {
  final String emailOrPhone;
  final String otp;
  VerifyForgotPasswordOtpParams({required this.emailOrPhone, required this.otp});
}

class VerifyForgotPasswordOtp {
  final AuthRepository repository;
  VerifyForgotPasswordOtp(this.repository);

  Future<Either<Failure, void>> call(VerifyForgotPasswordOtpParams params) async {
    return repository.verifyForgotPasswordOtp(emailOrPhone: params.emailOrPhone, otp: params.otp);
  }
}
