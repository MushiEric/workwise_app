import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/assets/data/models/asset_model.dart';

void main() {
  test('AssetModel.fromJson parses common fields correctly', () {
    final json = {
      "id": 67,
      "asset_id": "",
      "type": "1",
      "name": "Jeep",
      "registration_number": "T 253 FYG",
      "model": "",
      "chassis": "",
      "ownership": "1",
      "company": "1",
      "cargo_capacity": "",
      "cargo_unit": "1",
      "image": "",
      "document": "",
      "fuel_type": "",
      "fuel_consuption": 0,
      "distance_unit": "Kilometer",
      "vin": "",
      "make": "",
      "year": "",
      "engine_size": "",
      "mileage": "",
      "status": "1",
      "linked_vehicle": null,
      "is_available": 1,
      "is_active": 1,
      "is_dispatched": 0,
      "created_by": 11,
      "is_posted": 0,
      "updated_by": 11,
      "created_at": "2025-10-20T12:04:08.000000Z",
      "updated_at": "2025-10-20T12:04:08.000000Z",
      "archive": 0,
      "default": 0,
      "gps_label": null,
      "unit_number": null,
      "address": null,
      "latitude": null,
      "longitude": null,
      "last_transmit": null,
      "speed": null,
      "ignition": null,
      "battery": null,
      "gps_valid": null,
      "satellites": null,
      "heading": null,
      "gps_type": null,
      "has_gps": false
    };

    final model = AssetModel.fromJson(json);

    expect(model.id, 67);
    expect(model.name, 'Jeep');
    expect(model.registrationNumber, 'T 253 FYG');
    expect(model.status, '1');
    expect(model.isAvailable, 1);
    expect(model.hasGps, isFalse);
  });
}
