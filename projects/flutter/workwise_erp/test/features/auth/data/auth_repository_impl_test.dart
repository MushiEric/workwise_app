import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:workwise_erp/core/storage/token_local_data_source.dart';
import 'package:workwise_erp/features/auth/data/repositories/auth_repository_impl.dart';

class MockDio extends Mock implements Dio {}
class MockTokenStorage extends Mock implements TokenLocalDataSource {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataSource remote;
  late AuthRepositoryImpl repository;
  late MockTokenStorage mockTokenStorage;

  setUp(() {
    mockDio = MockDio();
    mockTokenStorage = MockTokenStorage();
    remote = AuthRemoteDataSource(mockDio);
    when(() => mockTokenStorage.saveToken(any())).thenAnswer((_) async {});
    repository = AuthRepositoryImpl(remote, mockTokenStorage);
  });

  test('fetchCurrentUser returns Right(User) when remote returns valid JSON', () async {
    final json = {
      'id': 1,
      'name': 'Alice',
      'email': 'alice@example.com',
      'is_admin': 0,
      'is_active': 1,
      'messenger_color': '#2180f3',
      'dark_mode': 0,
      'is_email_verified': 1,
      'created_at': '2024-01-01T12:00:00Z',
      'updated_at': '2024-01-02T12:00:00Z'
    };

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/api/user'),
          data: json,
          statusCode: 200,
        ));

    final Either<Failure, dynamic> result = await repository.fetchCurrentUser();

    expect(result.isRight, true);
    result.fold(
      (l) => fail('expected Right, got Failure: ${l.message}'),
      (r) {
        expect(r.email, 'alice@example.com');
        expect(r.name, 'Alice');
        expect(r.isActive, true);
        expect(r.isAdmin, false);
      },
    );
  });

  test('fetchCurrentUser returns TimeoutFailure on request timeout', () async {
    when(() => mockDio.get(any())).thenThrow(DioException(
      requestOptions: RequestOptions(path: '/api/user'),
      type: DioExceptionType.connectionTimeout,
      error: 'timed out',
    ));

    final Either<Failure, dynamic> result = await repository.fetchCurrentUser();

    expect(result.isLeft, true);
    result.fold(
      (l) => expect(l, isA<TimeoutFailure>()),
      (r) => fail('expected Left(TimeoutFailure) but got Right'),
    );
  });

  test('fetchCurrentUser returns NetworkFailure on connection error', () async {
    when(() => mockDio.get(any())).thenThrow(DioException(
      requestOptions: RequestOptions(path: '/api/user'),
      type: DioExceptionType.connectionError,
      error: 'connection failed',
    ));

    final Either<Failure, dynamic> result = await repository.fetchCurrentUser();

    expect(result.isLeft, true);
    result.fold(
      (l) => expect(l, isA<NetworkFailure>()),
      (r) => fail('expected Left(NetworkFailure) but got Right'),
    );
  });

  test('fetchCurrentUser returns ServerFailure on bad response', () async {
    when(() => mockDio.get(any())).thenThrow(DioException(
      requestOptions: RequestOptions(path: '/api/user'),
      type: DioExceptionType.badResponse,
      error: '500',
    ));

    final Either<Failure, dynamic> result = await repository.fetchCurrentUser();

    expect(result.isLeft, true);
    result.fold(
      (l) => expect(l, isA<ServerFailure>()),
      (r) => fail('expected Left(ServerFailure) but got Right'),
    );
  });
}

