import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/login.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/logout.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../state/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Login loginUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final UpdateProfile? updateProfileUseCase;
  final Logout? logoutUseCase;
  final void Function(String technical)? onErrorLog;

  AuthNotifier({required this.loginUseCase, required this.getCurrentUserUseCase, this.updateProfileUseCase, this.logoutUseCase, this.onErrorLog}) : super(const AuthState.initial());

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading('Signing in...');

    final res = await loginUseCase.call(LoginParams(email: email, password: password));
    res.fold(
      (failure) {
        // Log technical details for developers/monitoring and record last technical error
        final tech = failure.message;
        // console log
        // ignore: avoid_print
        print('Login failed (technical): $tech');
        // persist to provider for diagnostics (if callback provided)
        onErrorLog?.call(tech);
        state = AuthState.error(_friendlyMessageForFailure(failure));
      },
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> loadCurrentUser() async {
    state = const AuthState.loading('Loading user...');
    final res = await getCurrentUserUseCase.call();
    res.fold(
      (f) {
        // Log technical detail and record it for diagnostics
        final tech = f.message;
        // ignore: avoid_print
        print('Load current user failed (technical): $tech');
        onErrorLog?.call(tech);
        state = AuthState.error(_friendlyMessageForFailure(f));
      },
      (u) => state = AuthState.authenticated(u),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> payload) async {
    if (updateProfileUseCase == null) return;
    // Snapshot the current authenticated state so we can restore it on failure.
    final previousState = state;
    state = const AuthState.loading('Updating profile...');
    final res = await updateProfileUseCase!.call(payload);
    res.fold(
      (f) {
        final tech = f.message;
        // ignore: avoid_print
        print('Update profile failed (technical): $tech');
        onErrorLog?.call(tech);
        // Restore the previous authenticated state so user data / permissions
        // are not wiped out by the error.
        state = previousState.maybeWhen(
          authenticated: (u) => AuthState.authenticated(u),
          orElse: () => AuthState.error(_friendlyMessageForFailure(f)),
        );
        // Throw so the calling page's try/catch can surface the error to the UI.
        throw Exception(_friendlyMessageForFailure(f));
      },
      (u) => state = AuthState.authenticated(u),
    );
  }

  Future<void> logout() async {
    if (logoutUseCase == null) return;
    state = const AuthState.loading('Logging out...');
    final res = await logoutUseCase!.call();
    res.fold(
      (f) {
        final tech = f.message;
        // ignore: avoid_print
        print('Logout failed (technical): $tech');
        onErrorLog?.call(tech);
        state = AuthState.error('Failed to logout.');
      },
      (_) {
        // Clear auth state
        state = const AuthState.initial();
      },
    );
  }

  String _friendlyMessageForFailure(dynamic failure) {
    // Map Failure types to user-friendly messages
    // If server provided a helpful message, prefer it for ServerFailure
    if (failure is ServerFailure) {
      final msg = failure.message;
      if (msg.isNotEmpty && msg.toLowerCase() != 'server failure') return msg;
      return 'Unable to sign in right now. Please try again later.';
    }

    switch (failure.runtimeType) {
      case TimeoutFailure:
        return 'Request timed out. Please check your connection and try again.';
      case NetworkFailure:
        return 'No internet connection. Please check your network and try again.';
      case CacheFailure:
        return 'An unexpected error occurred. Please try again.';
      default:
        // fallback friendly message
        return 'Something went wrong. Please try again.';
    }
  }
}
