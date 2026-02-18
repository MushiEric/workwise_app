import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/features/auth/data/datasources/auth_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataSource remote;

  setUp(() {
    mockDio = MockDio();
    remote = AuthRemoteDataSource(mockDio);
  });

  test('login wraps unexpected exceptions with ServerException containing original message', () async {
    when(() => mockDio.post(any(), data: any(named: 'data'), options: any(named: 'options'))).thenThrow(Exception('parse error'));

    expect(
      () async => await remote.login(email: 'a@b.com', password: 'p'),
      throwsA(isA<ServerException>().having((e) => e.message, 'message', contains('parse error'))),
    );
  });
}
