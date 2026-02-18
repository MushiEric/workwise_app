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

  test('getJobcardSettings parses list from data envelope', () async {
    final respJson = {
      'status': 200,
      'data': [
        {'id': 1, 'name': 'Open', 'color': '#FF0000'},
        {'id': 2, 'name': 'In progress', 'color': '#FFFF00'}
      ]
    };

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/jobcard/getJobCardSetting'),
          data: respJson,
          statusCode: 200,
        ));

    final list = await remote.getJobcardSettings();
    expect(list, isA<List>());
    expect(list.first['name'], 'Open');
  });

  test('getJobcardSettings parses JSON string payload', () async {
    final arr = [
      {'id': 3, 'name': 'Allocate Spares', 'color': '#457af7'}
    ];

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/jobcard/getJobCardSetting'),
          data: json.encode(arr),
          statusCode: 200,
        ));

    final list = await remote.getJobcardSettings();
    expect(list.first['name'], contains('Allocate Spares'));
  });

  test('getJobcardSettings throws ServerException on HTML response', () async {
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/jobcard/getJobCardSetting'),
          data: '<html>Not Found</html>',
          statusCode: 500,
        ));

    expect(() => remote.getJobcardSettings(), throwsA(isA<Exception>()));
  });
}
