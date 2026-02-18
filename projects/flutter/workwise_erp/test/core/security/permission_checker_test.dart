import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/core/security/permission_checker.dart';
import 'package:workwise_erp/features/auth/domain/entities/role.dart';
import 'package:workwise_erp/features/auth/domain/entities/permission.dart';
import 'package:workwise_erp/features/auth/domain/entities/user.dart';

void main() {
  test('PermissionChecker recognizes permissions from roles', () {
    final user = User(
      id: 1,
      name: 'Alice',
      roles: [
        Role(id: 4, name: 'company', permissions: [
          Permission(id: 1, name: 'show pos dashboard'),
          Permission(id: 3, name: 'show hrm dashboard'),
        ])
      ],
    );

    final checker = PermissionChecker(user);
    expect(checker.hasPermission('show pos dashboard'), isTrue);
    expect(checker.hasPermission('SHOW HRM DASHBOARD'), isTrue); // case-insensitive
    expect(checker.hasPermission('show crm dashboard'), isFalse);
    expect(checker.hasAnyPermission(['show crm dashboard', 'show pos dashboard']), isTrue);
  });
}
