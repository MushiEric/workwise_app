import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/features/project/data/datasources/project_remote_data_source.dart';
import 'package:workwise_erp/features/project/data/models/project_model.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ProjectRemoteDataSource remote;

  setUp(() {
    mockDio = MockDio();
    remote = ProjectRemoteDataSource(mockDio);
  });

  test('getProjects parses list with title field', () async {
    final respJson = [
      {'id': 1, 'title': 'Proj A'}
    ];

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/get-projects'),
          data: respJson,
          statusCode: 200,
        ));

    final list = await remote.getProjects();
    expect(list, isA<List<ProjectModel>>());
    expect(list.first.name, 'Proj A');
  });

  test('getProjects parses wrapped data.projects', () async {
    final respJson = {'data': {'projects': [{'id': 2, 'name': 'Proj B'}]}};

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/get-projects'),
          data: respJson,
          statusCode: 200,
        ));

    final list = await remote.getProjects();
    expect(list.first.name, 'Proj B');
  });

  test('getProjects parses JSON string payload', () async {
    final arr = [
      {'id': 3, 'project_name': 'Proj C'}
    ];

    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/get-projects'),
          data: json.encode(arr),
          statusCode: 200,
        ));

    final list = await remote.getProjects();
    expect(list.first.name, 'Proj C');
  });

  test('getProjects throws ServerException on HTML response', () async {
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/get-projects'),
          data: '<html>Not Found</html>',
          statusCode: 200,
        ));

    final call = () => remote.getProjects();
    expect(call, throwsA(isA<ServerException>()));
    try {
      await call();
    } on ServerException catch (e) {
      expect(e.message, contains('/get-projects'));
      expect(e.message, contains('Preview'));
    }
  });

  test('getProjectById throws ServerException with request path when server returns HTML', () async {
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/projects/5'),
          data: '<html>Server Error</html>',
          statusCode: 500,
        ));

    expect(() => remote.getProjectById(5), throwsA(isA<ServerException>()));

    try {
      await remote.getProjectById(5);
    } on ServerException catch (e) {
      expect(e.message, contains('/projects/5'));
      expect(e.message, contains('status: 500'));
    }
  });

  test('getProjectTasks throws ServerException with request path when server returns HTML', () async {
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/projects/7/tasks'),
          data: '<html>Bad</html>',
          statusCode: 404,
        ));

    expect(() => remote.getProjectTasks(7), throwsA(isA<ServerException>()));

    try {
      await remote.getProjectTasks(7);
    } on ServerException catch (e) {
      expect(e.message, contains('/projects/7/tasks'));
      expect(e.message, contains('status: 404'));
    }
  });
}

