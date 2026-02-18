import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/auth/data/models/user_model.dart';

void main() {
  test('UserModel.fromJson maps roles and permissions to domain correctly', () {
    final Map<String, dynamic> json = {
      'id': 3,
      'name': 'Eric',
      'email': 'eric@example.com',
      'roles': [
        {
          'id': 4,
          'name': 'company',
          'permissions': [
            {'id': 1, 'name': 'show pos dashboard'},
            {'id': 2, 'name': 'show crm dashboard'},
          ],
        }
      ],
    };

    final model = UserModel.fromJson(json);
    final domain = model.toDomain();

    expect(domain.roles, isNotNull);
    expect(domain.roles!.length, 1);
    final role = domain.roles!.first;
    expect(role.id, 4);
    expect(role.name, 'company');
    expect(role.permissions, isNotNull);
    expect(role.permissions!.map((p) => p.name), contains('show crm dashboard'));
  });
}
