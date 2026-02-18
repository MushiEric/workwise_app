import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataSource remote;

  setUp(() {
    mockDio = MockDio();
    remote = AuthRemoteDataSource(mockDio);
  });

  test('login throws ServerException when API returns status:false', () async {
    final resp = {'status': false, 'message': 'Wrong credentials'};
    when(() => mockDio.post(any(), data: any(named: 'data'), options: any(named: 'options'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          data: resp,
          statusCode: 200,
        ));

    expect(() => remote.login(email: 'x', password: 'y'), throwsA(isA<ServerException>()));
    try {
      await remote.login(email: 'x', password: 'y');
    } on ServerException catch (e) {
      expect(e.message, 'Wrong credentials');
    }
  });

  test('login throws ServerException when response lacks token and user', () async {
    final resp = {'message': 'Invalid login'};
    when(() => mockDio.post(any(), data: any(named: 'data'), options: any(named: 'options'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          data: resp,
          statusCode: 200,
        ));

    expect(() => remote.login(email: 'x', password: 'y'), throwsA(isA<ServerException>()));
  });
}
