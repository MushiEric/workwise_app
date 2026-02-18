import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/features/sales/data/datasources/sales_remote_data_source.dart';
import 'package:workwise_erp/features/sales/data/models/order_model.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late SalesRemoteDataSource remote;

  setUp(() {
    mockDio = MockDio();
    remote = SalesRemoteDataSource(mockDio);
  });

  test('returns orders when response is Map with data list', () async {
    final respJson = {
      'data': [
        {'id': 1, 'order_number': 'ORD-1'}
      ]
    };

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/order/getRecentOrders'),
          data: respJson,
          statusCode: 200,
        ));

    final list = await remote.getRecentOrders();
    expect(list, isA<List<OrderModel>>());
    expect(list.length, 1);
    expect(list.first.id, 1);
  });

  test('parses JSON string payload', () async {
    final arr = [
      {'id': 2, 'order_number': 'ORD-2'}
    ];

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/order/getRecentOrders'),
          data: json.encode(arr),
          statusCode: 200,
        ));

    final list = await remote.getRecentOrders();
    expect(list.length, 1);
    expect(list.first.id, 2);
  });

  test('throws ServerException when server returns HTML', () async {
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/order/getRecentOrders'),
          data: '<html>Not Found</html>',
          statusCode: 200,
        ));

    expect(() => remote.getRecentOrders(), throwsA(isA<ServerException>()));
  });
}
