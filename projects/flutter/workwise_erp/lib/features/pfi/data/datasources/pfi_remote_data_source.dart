import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../models/pfi_model.dart';

class PfiRemoteDataSource {
  final Dio client;
  PfiRemoteDataSource(this.client);

  List<Map<String, dynamic>> _extractListFromRaw(dynamic raw, {List<String>? keys}) {
    keys ??= ['data', 'items', 'records', 'payload', 'proposals'];
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

  /// GET /sales/getSaleOrderPFI
  Future<List<PfiModel>> getPfis() async {
    try {
      final resp = await client.get('/sales/getSaleOrderPFI');
      final list = _extractListFromRaw(resp.data);

      final models = <PfiModel>[];

      for (final raw in list) {
        try {
          final src = Map<String, dynamic>.from(raw);
          models.add(PfiModel.fromJson(src));
        } catch (err) {
          // ignore: avoid_print
          print('warning: failed to parse pfi item: $err');
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
