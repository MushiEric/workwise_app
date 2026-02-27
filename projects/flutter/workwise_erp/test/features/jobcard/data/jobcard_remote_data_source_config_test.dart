
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

  test('getJobcardConfig parses single settings object from envelope', () async {
    final respJson = {
      'status': 200,
      'data': {
        'id': 1,
        'enable_reminder': 0,
        'jobcard_prefix': 'JB -',
        'jobcard_number_format': 'year_number'
      }
    };

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/jobcard/getJobCardSetting'),
          data: respJson,
          statusCode: 200,
        ));

    final map = await remote.getJobcardConfig();
    expect(map['jobcard_prefix'], 'JB -');
    expect(map['enable_reminder'], 0);
  });
}
