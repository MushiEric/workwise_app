import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/notification_model.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class NotificationRemoteDataSource {
  final Dio client;
  NotificationRemoteDataSource(this.client);

  List<Map<String, dynamic>> _extractListFromRaw(dynamic raw, {List<String>? keys}) {
    keys ??= ['data', 'items', 'records', 'notifications', 'payload'];
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

  /// GET /getNotifications?is_opened=0
  Future<List<NotificationModel>> getNotifications({int isOpened = 0}) async {
    try {
      final resp = await client.get('/getNotifications', queryParameters: {'is_opened': isOpened});
      final list = _extractListFromRaw(resp.data);

      final models = <NotificationModel>[];
      for (final raw in list) {
        try {
          final src = Map<String, dynamic>.from(raw);
          models.add(NotificationModel.fromJson(src));
        } catch (err) {
          // skip malformed items but continue
          // ignore: avoid_print
          print('warning: failed to parse notification item: $err');
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
