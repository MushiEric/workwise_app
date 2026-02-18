import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/asset_model.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class AssetRemoteDataSource {
  final Dio client;
  AssetRemoteDataSource(this.client);

  // tolerant extractor used across the app (accepts envelope shapes and JSON strings)
  List<Map<String, dynamic>> _extractListFromRaw(dynamic raw, {List<String>? keys}) {
    keys ??= ['data', 'assets', 'records', 'payload'];
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

  /// GET /vehicle/getAsset
  Future<List<AssetModel>> getAssets() async {
    try {
      final resp = await client.get('/vehicle/getAsset');
      final list = _extractListFromRaw(resp.data, keys: ['data', 'assets', 'records']);

      final models = <AssetModel>[];
      for (final raw in list) {
        try {
          final Map<String, dynamic> src = Map<String, dynamic>.from(raw);
          final normalized = _normalizeAssetJson(src);
          models.add(AssetModel.fromJson(normalized));
        } catch (err) {
          // skip malformed items but continue processing the rest
          // ignore: avoid_print
          print('Warning: failed to parse asset item: $err');
        }
      }

      return models;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Normalize common fields that may arrive as different types
  Map<String, dynamic> _normalizeAssetJson(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);

    dynamic asString(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;
      if (v is num || v is bool) return v.toString();
      if (v is Map) {
        if (v.containsKey('name') && v['name'] is String) return v['name'] as String;
        return v.toString();
      }
      return v.toString();
    }

    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      if (v is Map && v.containsKey('id')) return asInt(v['id']);
      return null;
    }

    bool? asBool(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      if (v is int) return v == 1;
      if (v is num) return v.toInt() == 1;
      if (v is String) return v == '1' || v.toLowerCase() == 'true';
      return null;
    }

    num? asNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v;
      if (v is String) return num.tryParse(v);
      return null;
    }

    out['id'] = asInt(out['id']);
    out['asset_id'] = asString(out['asset_id']);
    out['registration_number'] = asString(out['registration_number']);
    out['name'] = asString(out['name']);
    out['model'] = asString(out['model']);
    out['image'] = asString(out['image']);
    out['year'] = asString(out['year']);
    out['status'] = asString(out['status']);
    out['is_available'] = asInt(out['is_available']) ?? asInt(out['isAvailable']) ?? 0;
    out['is_active'] = asInt(out['is_active']) ?? asInt(out['isActive']) ?? 0;
    out['has_gps'] = asBool(out['has_gps']) ?? false;
    out['vin'] = asString(out['vin']);
    out['make'] = asString(out['make']);
    out['company'] = asString(out['company']);
    out['fuel_consuption'] = asNum(out['fuel_consuption']);
    out['created_at'] = asString(out['created_at']);

    return out;
  }
}
