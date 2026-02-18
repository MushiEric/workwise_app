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

  test('getJobcards parses list from data envelope', () async {
    final respJson = {
      'status': 200,
      'data': [
        {'id': 1, 'jobcard_number': 'JB-1'}
      ]
    };

    when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/jobcard/getJobCard'),
          data: respJson,
          statusCode: 200,
        ));

    final list = await remote.getJobcards();
    expect(list, isA<List>());
    expect(list.first.jobcardNumber, contains('JB-1'));
  });

  test('getJobcards parses JSON string payload', () async {
    final arr = [
      {'id': 2, 'jobcard_number': 'JB-2'}
    ];

    when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/jobcard/getJobCard'),
          data: json.encode(arr),
          statusCode: 200,
        ));

    final list = await remote.getJobcards();
    expect(list.first.jobcardNumber, contains('JB-2'));
  });

  test('getJobcards throws ServerException on HTML response', () async {
    when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/jobcard/getJobCard'),
          data: '<html>Not Found</html>',
          statusCode: 500,
        ));

    expect(() => remote.getJobcards(), throwsA(isA<Exception>()));
  });
}
