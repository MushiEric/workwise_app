import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/security/permission_checker.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';

final permissionCheckerProvider = Provider<PermissionChecker>((ref) {
  final authState = ref.watch(authNotifierProvider);
  // get authenticated user if present
  var user = authState.maybeWhen(authenticated: (u) => u, orElse: () => null);
  return PermissionChecker(user);
});