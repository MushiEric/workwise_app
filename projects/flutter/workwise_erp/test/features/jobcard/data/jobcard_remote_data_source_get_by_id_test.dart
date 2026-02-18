import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/features/jobcard/data/datasources/jobcard_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late JobcardRemoteDataSource remote;

  setUp(() {
    mockDio = MockDio();
    remote = JobcardRemoteDataSource(mockDio);
  });

  test('getJobcardById parses data object', () async {
    final respJson = json.decode(await Future.value(_sample));

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/jobcard/getJobCardRow/20'),
          data: respJson,
          statusCode: 200,
        ));

    final model = await remote.getJobcardById(20);
    expect(model.id, 20);
    expect(model.items?.length, greaterThan(0));
    expect(model.logs?.length, greaterThan(0));
    expect(model.statusRow?['name'], 'In progress');
  });
}

const _sample = '''
{
    "status": 200,
    "data": {
        "id": 20,
        "vehicle_id": 0,
        "grand_total": "750000.00",
        "jobcard_number": "JB -2025/124016",
        "status": "2",
        "inspection": null,
        "technician_id": "[]",
        "incharge_id": null,
        "reported_date": "2025-11-14 15:40:03",
        "reported_time": null,
        "description": null,
        "dispatched_date": "2025-11-21 15:40:0",
        "dispatched_time": null,
        "service": "NEEDING BRAKES",
        "related_to": "Vehicle",
        "receiver": "8",
        "contact": null,
        "support_id": null,
        "receiver_name": null,
        "notes": null,
        "attachment": null,
        "created_by": 11,
        "user_creator_id": 190,
        "updated_by": 11,
        "created_at": "2025-11-14T12:41:48.000000Z",
        "updated_at": "2025-11-14T13:16:44.000000Z",
        "archive": 0,
        "supervisor": null,
        "location": null,
        "separation_item": 0,
        "quantity": 0,
        "proposal_id": null,
        "departments": "[]",
        "encrypted_id": "xyz",
        "inspections": [],
        "user_creator": null,
        "items": [
            {
                "id": 29,
                "jobcard_id": 20,
                "item_id": 11,
                "item_name": "SINKS",
                "is_new_item": "0",
                "qty": 5,
                "price": 150000,
                "unit_id": 5,
                "item_description": "",
                "item_description2": null,
                "attachment": null,
                "created_by": 11,
                "updated_by": 11,
                "created_at": "2025-11-14T12:41:48.000000Z",
                "updated_at": "2025-11-14T12:41:48.000000Z",
                "archive": 0,
                "type": "product",
                "machine_id": ""
            }
        ],
        "status_row": {
            "id": 2,
            "name": "In progress",
            "color": "#FFFF00",
            "icon": null,
            "created_by": 1,
            "updated_by": 1,
            "created_at": "2024-07-04T07:41:34.000000Z",
            "updated_at": "2024-07-04T07:41:34.000000Z",
            "archive": 0
        },
        "logs": [
            { "id": 45, "jobcard_id": 20, "status": "1", "created_at": "2025-11-14T12:41:48.000000Z", "status_row": {"id":1, "name":"Open"} },
            { "id": 50, "jobcard_id": 20, "status": "2", "created_at": "2025-11-14T13:09:14.000000Z", "status_row": {"id":2, "name":"In progress"} }
        ]
    }
}
''';