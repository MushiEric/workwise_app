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

  // ─────────────────────────────────────────────────────────────
  // FETCH CURRENT USER
  // ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, domain.User>> fetchCurrentUser() async {
    try {
      final UserModel model = await remote.fetchCurrentUser();
      return Either.right(model.toDomain());
    }

    // ── SERVER EXCEPTION ───────────────────────────────────────
    on ServerException catch (e) {
      final msg = e.message.toLowerCase();

      // Any server-side error likely means token is invalid
      try {
        await _tokenStorage.deleteToken();
      } catch (_) {}

      if (msg.contains('invalid server response')) {
        return const Either.left(
          ServerFailure('Session expired. Please sign in again.'),
        );
      }

      return Either.left(ServerFailure(e.message));
    }

    // ── NETWORK EXCEPTION ──────────────────────────────────────
    on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    }

    // ── TIMEOUT EXCEPTION ──────────────────────────────────────
    on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    }

    // ── UNKNOWN ERROR ───────────────────────────────────────────
    catch (_) {
      try {
        await _tokenStorage.deleteToken();
      } catch (_) {}

      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, domain.User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserModel model =
          await remote.login(email: email, password: password);

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
    } catch (_) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // FORGOT PASSWORD
  // ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, void>> forgotPassword({
    required String emailOrPhone,
  }) async {
    try {
      await remote.forgotPassword(emailOrPhone: emailOrPhone);
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (_) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // VERIFY OTP
  // ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, void>> verifyForgotPasswordOtp({
    required String emailOrPhone,
    required String otp,
  }) async {
    try {
      await remote.verifyForgotPasswordOtp(
        emailOrPhone: emailOrPhone,
        otp: otp,
      );
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (_) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // CHANGE PASSWORD
  // ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, void>> changePasswordUsingOtp({
    required String emailOrPhone,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await remote.changePasswordUsingOtp(
        emailOrPhone: emailOrPhone,
        otp: otp,
        password: newPassword,
      );
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (_) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // UPDATE PROFILE
  // ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, domain.User>> updateProfile(
      Map<String, dynamic> payload) async {
    try {
      final UserModel model = await remote.updateProfile(payload);
      return Either.right(model.toDomain());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Either.left(TimeoutFailure(e.message));
    } catch (_) {
      return const Either.left(ServerFailure('Unexpected error'));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _tokenStorage.deleteToken();
      return const Either.right(null);
    } catch (_) {
      return const Either.left(ServerFailure('Failed to clear session'));
    }
  }
}
