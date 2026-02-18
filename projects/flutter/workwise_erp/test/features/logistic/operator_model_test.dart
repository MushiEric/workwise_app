import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/logistic/data/models/operator_model.dart';

void main() {
  test('OperatorModel.fromJson parses typical operator JSON', () {
    final json = {
      "id": 10,
      "name": "John Doe",
      "phone": "+254700000000",
      "email": "john@example.com",
      "avatar": "avatars/john.jpg",
      "license_number": "D-12345",
      "status": "available",
      "vehicle_id": 5,
      "created_at": "2025-11-01T10:00:00.000Z"
    };

    final m = OperatorModel.fromJson(json);

    expect(m.id, 10);
    expect(m.name, 'John Doe');
    expect(m.phone, '+254700000000');
    expect(m.licenseNumber, 'D-12345');
    expect(m.vehicleId, 5);
  });

  test('OperatorModel.fromJson builds name from first/middle/last and falls back to user.name', () {
    final json1 = {
      "id": 11,
      "first_name": "Jane",
      "middle_name": "X",
      "last_name": "Roe",
      "phone": "255700111222",
    };
    final m1 = OperatorModel.fromJson(json1);
    expect(m1.name, 'Jane X Roe');

    final json2 = {
      "id": 12,
      "user": {"name": "Nested Name", "phone": "255700000111"}
    };
    final m2 = OperatorModel.fromJson(json2);
    expect(m2.name, 'Nested Name');
    expect(m2.phone, '255700000111');
  });
}
