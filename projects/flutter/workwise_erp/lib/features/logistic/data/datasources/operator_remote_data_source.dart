import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/operator_model.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class OperatorRemoteDataSource {
  final Dio client;
  OperatorRemoteDataSource(this.client);

  List<Map<String, dynamic>> _extractListFromRaw(dynamic raw, {List<String>? keys}) {
    keys ??= ['data', 'operators', 'records', 'payload'];
    if (raw is List) return raw.map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList();
    if (raw is Map) {
      for (final k in keys) {
        if (raw[k] is List) return (raw[k] as List).map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList();
      }
      if (raw['data'] is Map) {
        final inner = raw['data'] as Map;
        for (final k in keys) {
          if (inner[k] is List) return (inner[k] as List).map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList();
        }
      }
    }
    if (raw is String) {
      final s = raw.trim();
      if (s.startsWith('<')) throw ServerException('Server returned HTML (check backend)');
      try {
        final decoded = json.decode(s);
        return _extractListFromRaw(decoded, keys: keys);
      } catch (_) {
        throw ServerException('Invalid JSON response from server');
      }
    }
    return <Map<String, dynamic>>[];
  }

  /// GET /operator/getOperator
  Future<List<OperatorModel>> getOperators() async {
    try {
      final resp = await client.get('/operator/getOperator');
      final list = _extractListFromRaw(resp.data, keys: ['data', 'operators', 'records']);

      final models = <OperatorModel>[];
      for (final raw in list) {
        try {
          final Map<String, dynamic> src = Map<String, dynamic>.from(raw);
          models.add(OperatorModel.fromJson(src));
        } catch (err) {
          // skip malformed items but continue
          // ignore: avoid_print
          print('Warning: failed to parse operator item: $err');
        }
      }

      return models;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
