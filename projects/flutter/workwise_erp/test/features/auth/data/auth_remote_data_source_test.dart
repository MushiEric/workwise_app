import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/features/auth/data/datasources/auth_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataSource remote;

  setUp(() {
    mockDio = MockDio();
    remote = AuthRemoteDataSource(mockDio);
  });

  test('login handles response with "users" wrapper and extracts token + user', () async {
    final respJson = {
      'status': 200,
      'message': 'Login successful',
      'token': 'abc123',
      'users': {
        'id': 3,
        'name': 'Eric',
        'email': 'eric@example.com',
      }
    };

    when(() => mockDio.post(any(), data: any(named: 'data'), options: any(named: 'options'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          data: respJson,
          statusCode: 200,
        ));

    final model = await remote.login(email: 'e@x.com', password: 'p');

    expect(model.id, 3);
    expect(model.name, 'Eric');
    expect(model.email, 'eric@example.com');
    expect(model.apiToken, 'abc123');
  });

  test('login with token-only response fetches /user and returns combined user', () async {
    final tokenOnly = {
      'status': 200,
      'message': 'Login successful',
      'token': 'tok-xyz',
    };

    final userJson = {
      'id': 42,
      'name': 'Fetched User',
      'email': 'fetched@example.com',
      'is_admin': 0,
      'is_active': 1,
      'type': 'operator',
    };

    when(() => mockDio.post(any(), data: any(named: 'data'), options: any(named: 'options'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          data: tokenOnly,
          statusCode: 200,
        ));

    when(() => mockDio.get('/user')).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/user'),
          data: userJson,
          statusCode: 200,
        ));

    final model = await remote.login(email: 'e@x.com', password: 'p');
    expect(model.id, 42);
    expect(model.apiToken, 'tok-xyz');
    expect(model.email, 'fetched@example.com');
    // `type` should have been converted into roles
    expect(model.roles, isNotNull);
    expect(model.roles!.first.name, equals('operator'));

  });

  test('fetchCurrentUser converts `type` into roles when present', () async {
    final resp = {'id': 99, 'name': 'Type User', 'email': 't@example.com', 'type': 'company'};

    when(() => mockDio.get('/user')).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/user'),
          data: resp,
          statusCode: 200,
        ));

    final model = await remote.fetchCurrentUser();
    expect(model.id, 99);
    expect(model.roles, isNotNull);
    expect(model.roles!.first.name, equals('company'));
  });

  test('login parses JSON string response', () async {
    final respJson = {'user': {'id': 21, 'name': 'Str User', 'email': 'str@example.com'}, 'token': 't1'};

    when(() => mockDio.post(any(), data: any(named: 'data'), options: any(named: 'options'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          data: json.encode(respJson),
          statusCode: 200,
        ));

    final model = await remote.login(email: 's@e.com', password: 'p');
    expect(model.id, 21);
    expect(model.apiToken, 't1');
    expect(model.email, 'str@example.com');
  });

  test('login throws ServerException when server returns HTML', () async {
    when(() => mockDio.post(any(), data: any(named: 'data'), options: any(named: 'options'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          data: '<html>Not found</html>',
          statusCode: 200,
        ));

    expect(() => remote.login(email: 'a@b.com', password: 'p'), throwsA(isA<ServerException>()));
  });

  test('updateProfile accepts stringified JSON and rejects HTML', () async {
    final user = {'id': 55, 'name': 'Updated', 'email': 'u@example.com'};
    when(() => mockDio.post('/user/updateProfile/', data: any(named: 'data'), options: any(named: 'options'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/user/updateProfile/'),
          data: json.encode({'data': user}),
          statusCode: 200,
        ));

    final model = await remote.updateProfile({'name': 'Updated'});
    expect(model.id, 55);

    when(() => mockDio.post('/user/updateProfile/', data: any(named: 'data'), options: any(named: 'options'))).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/user/updateProfile/'),
          data: '<html>Err</html>',
          statusCode: 200,
        ));

    expect(() => remote.updateProfile({'name': 'X'}), throwsA(isA<ServerException>()));
  });
}
