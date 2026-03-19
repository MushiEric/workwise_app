import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Fetch authenticated user and return Either<Failure, User>
  Future<Either<Failure, User>> fetchCurrentUser();

  /// Login with email/password and return Either<Failure, User>
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Request password reset (accepts email or phone). Sends OTP to email/SMS.
  ///
  /// Returns the backend message after requesting a reset (e.g. "Password reset initiated...").
  Future<Either<Failure, String>> forgotPassword({
    required String emailOrPhone,
  });

  /// Update user profile
  Future<Either<Failure, User>> updateProfile(Map<String, dynamic> payload);

  /// Logout / clear local session
  Future<Either<Failure, void>> logout();

  /// Verify OTP sent for forgot-password flow
  Future<Either<Failure, void>> verifyForgotPasswordOtp({
    required String emailOrPhone,
    required String otp,
  });

  /// Change password using OTP (forgot-password flow)
  Future<Either<Failure, void>> changePasswordUsingOtp({
    required String emailOrPhone,
    required String otp,
    required String newPassword,
  });

  /// Change password for an authenticated user.
  ///
  /// Requires the current password for validation.
  Future<Either<Failure, void>> changePasswordAuthenticated({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  });
}
