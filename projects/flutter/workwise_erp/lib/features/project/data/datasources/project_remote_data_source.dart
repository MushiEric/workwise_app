import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/exceptions_extended.dart';
import '../models/project_model.dart';
import '../models/project_task_model.dart';

class ProjectRemoteDataSource {
  final Dio client;
  ProjectRemoteDataSource(this.client);

  /// GET /get-projects
  Future<List<ProjectModel>> getProjects() async {
    try {
      final resp = await client.get('/get-projects');
      final raw = resp.data;

      // normalize to a List<Map<String, dynamic>> when possible
      List<Map<String, dynamic>> items = [];

      // helper to extract list from a map by common keys
      List<Map<String, dynamic>>? extractFromMap(Map m) {
        if (m['data'] is List) return (m['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (m['projects'] is List) return (m['projects'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (m['items'] is List) return (m['items'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (m['records'] is List) return (m['records'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (m['payload'] is List) return (m['payload'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        // nested `data` -> `projects` etc.
        if (m['data'] is Map) {
          final inner = m['data'] as Map;
          if (inner['projects'] is List) return (inner['projects'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          if (inner['items'] is List) return (inner['items'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
        return null;
      }

      if (raw is List) {
        items = raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else if (raw is Map) {
        final extracted = extractFromMap(raw);
        if (extracted != null) items = extracted;
      } else if (raw is String) {
        final s = raw.trim();
        if (s.startsWith('<')) {
          final preview = s.length > 200 ? '${s.substring(0, 200)}...' : s;
          throw ServerException('Server returned HTML for ${resp.requestOptions.path} (status: ${resp.statusCode ?? 'unknown'}). Preview: $preview');
        }
        try {
          final decoded = json.decode(s);
          if (decoded is List) {
            items = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          } else if (decoded is Map) {
            final extracted = extractFromMap(decoded);
            if (extracted != null) items = extracted;
          }
        } catch (_) {
          throw ServerException('Invalid JSON response from server');
        }
      }

      if (items.isEmpty) throw ServerException('Unexpected response format for projects');
      return items.map((e) => ProjectModel.fromJson(e)).toList();
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          throw ServerException(e.message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  /// GET /get-projects/{id} or /get-project/{id}
  Future<ProjectModel> getProjectById(int id) async {
    try {
      // Try /get-projects/{id} first (matches list endpoint pattern)
      // Fallback to /get-project/{id} if needed
      DioException? lastError;
      try {
        final resp = await client.get('/get-projects/$id');
        final raw = resp.data;

        // detect HTML error pages early so error message includes status code (tests expect this)
        if (raw is String) {
          final s = raw.trim();
          if (s.startsWith('<')) {
            final preview = s.length > 200 ? '${s.substring(0, 200)}...' : s;
            throw ServerException('Server returned HTML for ${resp.requestOptions.path} (status: ${resp.statusCode ?? 'unknown'}). Preview: $preview');
          }
        }

        Map<String, dynamic>? map = _extractProjectMap(raw, resp.requestOptions.path);
        if (map != null) {
          return _parseProjectMap(map);
        }
      } on DioException catch (e) {
        lastError = e;
        // If 404, try alternative endpoint
        if (e.response?.statusCode == 404) {
          try {
            final resp = await client.get('/get-project/$id');
            final raw = resp.data;

            if (raw is String) {
              final s = raw.trim();
              if (s.startsWith('<')) {
                final preview = s.length > 200 ? '${s.substring(0, 200)}...' : s;
                throw ServerException('Server returned HTML for ${resp.requestOptions.path} (status: ${resp.statusCode ?? 'unknown'}). Preview: $preview');
              }
            }

            Map<String, dynamic>? map = _extractProjectMap(raw, resp.requestOptions.path);
            if (map != null) {
              return _parseProjectMap(map);
            }
          } on DioException catch (e2) {
            lastError = e2;
          }
        } else {
          rethrow;
        }
      }
      
      // If both failed, throw the last error
      if (lastError != null) {
        throw lastError;
      }
      
      throw ServerException('Unexpected response format');
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          throw ServerException(e.message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }

  /// Helper to extract project map from response
  Map<String, dynamic>? _extractProjectMap(dynamic raw, String path) {
    Map<String, dynamic>? map;

    if (raw is Map<String, dynamic>) {
      map = raw;
    } else if (raw is String) {
      final s = raw.trim();
      if (s.startsWith('<')) {
        final preview = s.length > 200 ? '${s.substring(0, 200)}...' : s;
        throw ServerException('Server returned HTML for $path. Preview: $preview');
      }
      try {
        final decoded = json.decode(s);
        if (decoded is Map<String, dynamic>) map = decoded;
      } catch (_) {
        throw ServerException('Invalid JSON response from server');
      }
    }

    return map;
  }

  /// Helper to parse project map with common wrappers
  ProjectModel _parseProjectMap(Map<String, dynamic> map) {
    // common wrappers
    if (map.containsKey('data') && map['data'] is Map) {
      final dataMap = Map<String, dynamic>.from(map['data'] as Map);
      if (dataMap.containsKey('project') && dataMap['project'] is Map) {
        return ProjectModel.fromJson(Map<String, dynamic>.from(dataMap['project'] as Map));
      }
      return ProjectModel.fromJson(dataMap);
    }

    if (map.containsKey('project') && map['project'] is Map) {
      return ProjectModel.fromJson(Map<String, dynamic>.from(map['project'] as Map));
    }

    return ProjectModel.fromJson(map);
  }

  /// GET /projects/{id}/tasks
  Future<List<ProjectTaskModel>> getProjectTasks(int projectId) async {
    try {
      final resp = await client.get('/projects/$projectId/tasks');
      final raw = resp.data;

      List<Map<String, dynamic>> items = [];

      // helper to extract list from a map by common keys
      List<Map<String, dynamic>>? extractFromMap(Map m) {
        if (m['data'] is List) return (m['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (m['tasks'] is List) return (m['tasks'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (m['items'] is List) return (m['items'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (m['records'] is List) return (m['records'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (m['payload'] is List) return (m['payload'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (m['data'] is Map) {
          final inner = m['data'] as Map;
          if (inner['tasks'] is List) return (inner['tasks'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          if (inner['items'] is List) return (inner['items'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
        return null;
      }

      if (raw is List) {
        items = raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else if (raw is Map) {
        final extracted = extractFromMap(raw);
        if (extracted != null) items = extracted;
      } else if (raw is String) {
        final s = raw.trim();
        if (s.startsWith('<')) {
          final preview = s.length > 200 ? '${s.substring(0, 200)}...' : s;
          throw ServerException('Server returned HTML for ${resp.requestOptions.path} (status: ${resp.statusCode ?? 'unknown'}). Preview: $preview');
        }
        try {
          final decoded = json.decode(s);
          if (decoded is List) {
            items = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          } else if (decoded is Map) {
            final extracted = extractFromMap(decoded);
            if (extracted != null) items = extracted;
          }
        } catch (_) {
          throw ServerException('Invalid JSON response from server');
        }
      }

      if (items.isEmpty) throw ServerException('Unexpected response format for project tasks');
      return items.map((e) => ProjectTaskModel.fromJson(e)).toList();
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(e.message ?? 'Request timed out');
        case DioExceptionType.badResponse:
          throw ServerException(e.message ?? 'Server error');
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
        default:
          throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException('Unknown error: ${e.toString()}');
    }
  }
}
