import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/exceptions_extended.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/storage/token_local_data_source.dart';

import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';
import '../../../../core/storage/user_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenLocalDataSource _tokenStorage;
  final UserLocalDataSource _userStorage;

  AuthRepositoryImpl(this.remote, this._tokenStorage, this._userStorage);

  // ─────────────────────────────────────────────────────────────
  // FETCH CURRENT USER
  // ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, domain.User>> fetchCurrentUser() async {
    try {
      final UserModel model = await remote.fetchCurrentUser();

      // The /getProfile endpoint returns a lightweight user profile WITHOUT
      // roles/permissions.  If we blindly overwrite the cache, the
      // login-time permissions (which CAN be large) are lost and modules
      // disappear after every cold restart.
      //
      // Strategy: read the existing cached user. If it has roles, merge them
      // into the fresh profile before saving  so the cache always retains
      // the most recently known permissions.
      try {
        UserModel toCache = model;
        if (model.roles == null || model.roles!.isEmpty) {
          final existing = await _userStorage.readUser();
          if (existing != null) {
            final existingModel = UserModel.fromJson(existing);
            if (existingModel.roles != null &&
                existingModel.roles!.isNotEmpty) {
              toCache = model.copyWith(roles: existingModel.roles);
            }
          }
        }
        await _userStorage.saveUser(toCache.toJson());
      } catch (_) {}

      // Return the domain user with merged roles so Riverpod state is also
      // correct immediately (AuthNotifier does its own merge too, but this
      // ensures the cached value is trustworthy for the NEXT cold start).
      final domain.User domainUser =
          (model.roles != null && model.roles!.isNotEmpty)
              ? model.toDomain()
              : await _withMergedRoles(model);

      return Either.right(domainUser);
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

  /// Reads the cached user and merges its roles into [model]'s domain object.
  /// Used when /getProfile returns a bare profile without roles/permissions.
  Future<domain.User> _withMergedRoles(UserModel model) async {
    try {
      final existing = await _userStorage.readUser();
      if (existing != null) {
        final existingModel = UserModel.fromJson(existing);
        if (existingModel.roles != null && existingModel.roles!.isNotEmpty) {
          return model.copyWith(roles: existingModel.roles).toDomain();
        }
      }
    } catch (_) {}
    return model.toDomain();
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
      final UserModel model = await remote.login(
        email: email,
        password: password,
      );

      if (model.apiToken != null && model.apiToken!.isNotEmpty) {
        await _tokenStorage.saveToken(model.apiToken!);
      }
      // Cache user so permissions can be restored after restart.
      try {
        await _userStorage.saveUser(model.toJson());
      } catch (_) {}

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
  Future<Either<Failure, String>> forgotPassword({
    required String emailOrPhone,
  }) async {
    try {
      final message = await remote.forgotPassword(emailOrPhone: emailOrPhone);
      return Either.right(message);
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

  /// Change password for a signed-in user.
  @override
  Future<Either<Failure, void>> changePasswordAuthenticated({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await remote.changePasswordAuthenticated(
        currentPassword: currentPassword,
        password: password,
        passwordConfirmation: passwordConfirmation,
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
    Map<String, dynamic> payload,
  ) async {
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
      // Notify server (best-effort) to invalidate the session token.
      // If this fails, we still clear local state so the user cannot continue.
      try {
        await remote.logout();
      } catch (_) {
        // ignore: avoid_print
        print('Logout warning: server logout failed');
      }

      // Clear local session state.
      await _tokenStorage.deleteToken();
      await _userStorage.deleteUser();
      return const Either.right(null);
    } catch (_) {
      return const Either.left(ServerFailure('Failed to clear session'));
    }
  }
}
