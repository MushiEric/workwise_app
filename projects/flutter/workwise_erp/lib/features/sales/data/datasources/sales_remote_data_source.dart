import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/order_model.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class SalesRemoteDataSource {
  final Dio client;
  SalesRemoteDataSource(this.client);

  /// GET /order/getRecentOrders
  Future<List<OrderModel>> getRecentOrders() async {
    try {
      final resp = await client.get('/order/getRecentOrders');
      final raw = resp.data;

      // helper to extract list from common envelope shapes
      List<Map<String, dynamic>>? extractList(dynamic r) {
        if (r is List) return r.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (r is Map) {
          if (r['data'] is List) return (r['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          if (r['orders'] is List) return (r['orders'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          if (r['items'] is List) return (r['items'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          if (r['records'] is List) return (r['records'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          if (r['payload'] is List) return (r['payload'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          // nested data -> orders
          if (r['data'] is Map && (r['data'] as Map)['orders'] is List) return ((r['data'] as Map)['orders'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
        return null;
      }

      List<Map<String, dynamic>> items = [];

      if (raw is String) {
        final s = raw.trim();
        if (s.startsWith('<')) throw ServerException('Server returned HTML (check backend)');
        try {
          final decoded = json.decode(s);
          final extracted = extractList(decoded);
          if (extracted != null) items = extracted;
        } catch (_) {
          throw ServerException('Invalid JSON response from server');
        }
      } else {
        final extracted = extractList(raw);
        if (extracted != null) items = extracted;
      }

      if (items.isEmpty) throw ServerException('Unexpected response format for recent orders');

      final List<OrderModel> models = [];
      for (final rawItem in items) {
        try {
          final normalized = _normalizeOrderJson(rawItem);
          models.add(OrderModel.fromJson(normalized));
        } catch (err) {
          // skip malformed items but continue processing others
          // ignore: avoid_print
          print('Warning: failed to parse order item: $err');
        }
      }

      return models;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Defensive normalization so downstream models always receive expected types
  Map<String, dynamic> _normalizeOrderJson(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);

    dynamic asString(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;
      if (v is num || v is bool) return v.toString();
      if (v is Map) {
        if (v.containsKey('name') && v['name'] is String) {
          return v['name'] as String;
        }
        if (v.containsKey('title') && v['title'] is String) {
          return v['title'] as String;
        }
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

    num? asNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v;
      if (v is String) return num.tryParse(v.replaceAll(',', ''));
      return null;
    }

    Map<String, dynamic>? asMap(dynamic v) {
      if (v == null) return null;
      if (v is Map) return Map<String, dynamic>.from(v);
      return null;
    }

    List<Map<String, dynamic>> asListOfMaps(dynamic v) {
      if (v == null) return <Map<String, dynamic>>[];
      if (v is List) {
        return v
            .map(
              (e) =>
                  e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{},
            )
            .toList();
      }
      return <Map<String, dynamic>>[];
    }

    // Normalize primitive/string fields
    final stringFields = [
      'order_number',
      'title',
      'quotation',
      'start_date',
      'end_date',
      'created_at',
      'updated_at',
    ];
    for (final f in stringFields) {
      if (out.containsKey(f)) out[f] = asString(out[f]);
    }

    // Numeric fields
    if (out.containsKey('id')) out['id'] = asInt(out['id']);
    if (out.containsKey('customer_id')) {
      out['customer_id'] = asInt(out['customer_id']);
    }
    if (out.containsKey('amount')) out['amount'] = asNum(out['amount']);
    if (out.containsKey('payment_status')) {
      out['payment_status'] = asInt(out['payment_status']);
    }

    // Nested objects
    out['customer'] = asMap(out['customer']);
    out['user'] = asMap(out['user']);
    out['status_row'] = asMap(out['status_row']);
    out['payment_status_row'] = asMap(out['payment_status_row']);

    // Items: ensure list of maps and normalize child fields
    final rawItems = asListOfMaps(out['items']);
    final normalizedItems = <Map<String, dynamic>>[];
    for (final it in rawItems) {
      final m = Map<String, dynamic>.from(it);
      if (m.containsKey('order_id')) m['order_id'] = asString(m['order_id']);
      if (m.containsKey('item_id')) m['item_id'] = asString(m['item_id']);
      if (m.containsKey('price')) m['price'] = asString(m['price']);
      if (m.containsKey('quantity')) m['quantity'] = asString(m['quantity']);
      m['product'] = asMap(m['product']);
      m['package_unit'] = asMap(m['package_unit']);
      normalizedItems.add(m);
    }
    out['items'] = normalizedItems;

    // Truck list
    final rawTrucks = asListOfMaps(out['truck_list']);
    final normalizedTrucks = <Map<String, dynamic>>[];
    for (final t in rawTrucks) {
      final m = Map<String, dynamic>.from(t);
      if (m.containsKey('order_id')) m['order_id'] = asString(m['order_id']);
      m['id'] = asInt(m['id']);
      normalizedTrucks.add(m);
    }
    out['truck_list'] = normalizedTrucks;

    return out;
  }
}
