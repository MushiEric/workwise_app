import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/auth_repository.dart';

class ChangePasswordUsingOtpParams {
  final String emailOrPhone;
  final String otp;
  final String newPassword;
  ChangePasswordUsingOtpParams({required this.emailOrPhone, required this.otp, required this.newPassword});
}

class ChangePasswordUsingOtp {
  final AuthRepository repository;
  ChangePasswordUsingOtp(this.repository);

  Future<Either<Failure, void>> call(ChangePasswordUsingOtpParams params) async {
    return repository.changePasswordUsingOtp(
      emailOrPhone: params.emailOrPhone,
      otp: params.otp,
      newPassword: params.newPassword,
    );
  }
}
