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

  test('deleteJobcard sends DELETE to /jobcard/deleteJobCard/{id}', () async {
    when(() => mockDio.delete(any())).thenAnswer((_) async => Response(requestOptions: RequestOptions(path: '/jobcard/deleteJobCard/20'), statusCode: 200, data: {'status': 200}));

    await remote.deleteJobcard(20);

    verify(() => mockDio.delete('/jobcard/deleteJobCard/20')).called(1);
  });

  test('deleteJobcard throws ServerException on HTML response', () async {
    when(() => mockDio.delete(any())).thenThrow(DioException(requestOptions: RequestOptions(path: '/jobcard/deleteJobCard/20'), response: Response(requestOptions: RequestOptions(path: '/jobcard/deleteJobCard/20'), data: '<html></html>', statusCode: 500)));

    expect(() => remote.deleteJobcard(20), throwsA(isA<Exception>()));
  });
}
