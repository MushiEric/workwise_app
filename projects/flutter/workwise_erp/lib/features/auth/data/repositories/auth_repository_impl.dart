import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/exceptions_extended.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/storage/token_local_data_source.dart';

import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenLocalDataSource _tokenStorage;

  AuthRepositoryImpl(this.remote, this._tokenStorage);

  @override
  Future<Either<Failure, domain.User>> fetchCurrentUser() async {
    try {
      final UserModel model = await remote.fetchCurrentUser();
      return Either.right(model.toDomain());
    } on ServerException catch (e) {
      // Defensive: if server returned an unexpected response it may indicate
      // the stored token is invalid (happens after hot-restart/session expiry).
      // Clear local token to avoid repeated restore attempts and return a
      // friendly failure so the UI doesn't expose internal parsing errors.
      final msg = e.message?.toLowerCase() ?? '';
      if (msg.contains('invalid server response') || msg.contains('invalid server response when fetching user') || msg.contains('invalid server response:')) {
        try {
          await _tokenStorage.deleteToken();
        } catch (_) {}
        return const Either.left(ServerFailure('Session expired. Please sign in again.'));
      }

      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (e) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, domain.User>> login({required String email, required String password}) async {
    try {
      final UserModel model = await remote.login(email: email, password: password);
      // persist token if available
      if (model.apiToken != null && model.apiToken!.isNotEmpty) {
        await _tokenStorage.saveToken(model.apiToken!);
      }
      return Either.right(model.toDomain());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (e) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String emailOrPhone}) async {
    try {
      await remote.forgotPassword(emailOrPhone: emailOrPhone);
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (e) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyForgotPasswordOtp({required String emailOrPhone, required String otp}) async {
    try {
      await remote.verifyForgotPasswordOtp(emailOrPhone: emailOrPhone, otp: otp);
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (e) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, void>> changePasswordUsingOtp({required String emailOrPhone, required String otp, required String newPassword}) async {
    try {
      await remote.changePasswordUsingOtp(emailOrPhone: emailOrPhone, otp: otp, password: newPassword);
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (e) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, domain.User>> updateProfile(Map<String, dynamic> payload) async {
    try {
      final UserModel model = await remote.updateProfile(payload);
      return Either.right(model.toDomain());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (e) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _tokenStorage.deleteToken();
      return const Either.right(null);
    } catch (e) {
      return const Either.left(ServerFailure('Failed to clear session'));
    }
  }
}

