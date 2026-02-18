import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/features/support/data/datasources/support_remote_data_source.dart';
import 'package:workwise_erp/features/support/data/models/support_ticket_model.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late SupportRemoteDataSource remote;

  setUp(() {
    mockDio = MockDio();
    remote = SupportRemoteDataSource(mockDio);
  });

  test('returns tickets when response is Map with data list', () async {
    final respJson = {
      'data': [
        {'id': 11, 'subject': 'Help'}
      ]
    };

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/support/getSupportTicket'),
          data: respJson,
          statusCode: 200,
        ));

    final list = await remote.getSupportTickets();
    expect(list, isA<List<SupportTicketModel>>());
    expect(list.length, 1);
    expect(list.first.id, 11);
  });

  test('parses JSON string payload for tickets', () async {
    final arr = [
      {'id': 12, 'subject': 'Another'}
    ];

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/support/getSupportTicket'),
          data: json.encode(arr),
          statusCode: 200,
        ));

    final list = await remote.getSupportTickets();
    expect(list.length, 1);
    expect(list.first.id, 12);
  });

  test('throws ServerException when server returns HTML for tickets', () async {
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/support/getSupportTicket'),
          data: '<html>Not Found</html>',
          statusCode: 200,
        ));

    expect(() => remote.getSupportTickets(), throwsA(isA<ServerException>()));
  });
}
