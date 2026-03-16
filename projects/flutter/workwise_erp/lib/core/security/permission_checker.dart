import 'package:workwise_erp/features/auth/domain/entities/user.dart';

class PermissionChecker {
  final User? user;

  /// Flat list of permission names fetched directly from /user/getPermission.
  /// Checked first (takes precedence over role-based permissions from cache).
  final List<String> flatPermissions;

  PermissionChecker(this.user, {this.flatPermissions = const []});

  bool hasRole(String roleName) {
    if (user?.roles == null) return false;
    return user!.roles!.any(
      (r) => (r.name ?? '').toLowerCase() == roleName.toLowerCase(),
    );
  }

  bool hasPermission(String permissionName) {
    final normalized = permissionName.toLowerCase().trim();

    // 1. Check flat permissions from the dedicated /user/getPermission endpoint.
    if (flatPermissions.any((p) => p.toLowerCase().trim() == normalized)) {
      return true;
    }

    // 2. Fallback: check role-based permissions from the cached user object.
    if (user?.roles == null) return false;
    final perms = user!.roles!
        .expand((r) => r.permissions ?? [])
        .map((p) => (p.name ?? '').toLowerCase().trim())
        .toSet();
    return perms.contains(normalized);
  }

  bool hasAnyPermission(List<String> names) =>
      names.any((n) => hasPermission(n));
}
