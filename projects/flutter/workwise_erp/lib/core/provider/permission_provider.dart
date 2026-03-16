import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/security/permission_checker.dart';
import 'package:workwise_erp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/presentation/state/auth_state.dart';

/// Holds the flat list of permission names fetched from GET /user/getPermission.
/// Automatically fetches when the auth state becomes [AuthState.authenticated]
/// and clears on logout / unauthenticated state.
class PermissionsNotifier extends StateNotifier<List<String>> {
  final AuthRemoteDataSource _remote;
  PermissionsNotifier(this._remote) : super(const []);

  Future<void> fetch() async {
    final perms = await _remote.fetchPermissions();
    if (mounted) state = perms;
  }

  void clear() {
    if (mounted) state = const [];
  }
}

final permissionsNotifierProvider =
    StateNotifierProvider<PermissionsNotifier, List<String>>((ref) {
      final remote = ref.watch(authRemoteDataSourceProvider);
      final notifier = PermissionsNotifier(remote);

      // Reactively fetch / clear as the auth state changes.
      // fireImmediately: true ensures we run on first build (app restore via splash).
      ref.listen<AuthState>(authNotifierProvider, (_, next) {
        next.maybeWhen(
          authenticated: (_) => notifier.fetch(),
          orElse: () => notifier.clear(),
        );
      }, fireImmediately: true);

      return notifier;
    });

final permissionCheckerProvider = Provider<PermissionChecker>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final user = authState.maybeWhen(authenticated: (u) => u, orElse: () => null);
  final flatPermissions = ref.watch(permissionsNotifierProvider);
  return PermissionChecker(user, flatPermissions: flatPermissions);
});
