import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import 'package:workwise_erp/core/provider/token_provider.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/verify_forgot_password_otp.dart';
import '../../domain/usecases/change_password_using_otp.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/logout.dart';
import '../notifier/auth_notifier.dart';
import '../state/auth_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSource(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final tokenStorage = ref.watch(tokenLocalDataSourceProvider);
  return AuthRepositoryImpl(remote, tokenStorage);
});

/// Exposes the last technical API error (for debugging / diagnostics).
final lastApiErrorProvider = StateProvider<String?>((ref) => null);

/// Use-case provider
final getCurrentUserUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return GetCurrentUser(repo);
});

final loginUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return Login(repo);
});

final forgotPasswordUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return ForgotPassword(repo);
});

final updateProfileUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return UpdateProfile(repo);
});

final logoutUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return Logout(repo);
});

final verifyForgotPasswordOtpUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return VerifyForgotPasswordOtp(repo);
});

final changePasswordUsingOtpUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return ChangePasswordUsingOtp(repo);
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final login = ref.watch(loginUseCaseProvider);
  final getUser = ref.watch(getCurrentUserUseCaseProvider);
  final updateProfile = ref.watch(updateProfileUseCaseProvider);
  final logout = ref.watch(logoutUseCaseProvider);

  // pass a logger callback so AuthNotifier can record technical errors
  void recordTechnicalError(String technical) => ref.read(lastApiErrorProvider.notifier).state = technical;

  return AuthNotifier(
    loginUseCase: login,
    getCurrentUserUseCase: getUser,
    updateProfileUseCase: updateProfile,
    logoutUseCase: logout,
    onErrorLog: recordTechnicalError,
  );
});

final currentUserProvider = FutureProvider<Either<Failure, User>>((ref) async {
  final usecase = ref.watch(getCurrentUserUseCaseProvider);
  return usecase.call();
});
