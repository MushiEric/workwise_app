import 'package:workwise_erp/features/auth/domain/entities/user.dart';

class PermissionChecker {
  final User? user;
  PermissionChecker(this.user);

  bool hasRole(String roleName) {
    if (user?.roles == null) return false;
    return user!.roles!.any((r) => (r.name ?? '').toLowerCase() == roleName.toLowerCase());
  }

  bool hasPermission(String permissionName) {
    if (user?.roles == null) return false;
    final normalized = permissionName.toLowerCase().trim();
    final perms = user!.roles!
        .expand((r) => r.permissions ?? [])
        .map((p) => (p.name ?? '').toLowerCase().trim())
        .toSet();
    return perms.contains(normalized);
  }

  bool hasAnyPermission(List<String> names) => names.any((n) => hasPermission(n));
}
