import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/order_model.dart';
import '../models/order_status_model.dart';
import '../models/product_model.dart';
import '../models/package_unit_model.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class SalesRemoteDataSource {
  final Dio client;
  SalesRemoteDataSource(this.client);

  /// GET /order/getRecentOrders
  Future<List<OrderModel>> getRecentOrders([Map<String, dynamic>? params]) async {
    try {
      final defaultData = {
        "draw": "1",
        "start": "0",
        "length": "1000",
        "search[value]": "",
        "search[regex]": "false",
        "start_date": "2024-12-12",
        "end_date": "2026-12-12 23:59:59",
        "user": "All",
        "customer": "All",
        "vehicle": "All",
        "pickup": "All",
        "delivery": "All",
        "departure": "All"
      };

      final queryParams = params != null ? Map<String, dynamic>.from(params) : Map<String, dynamic>.from(defaultData);
      
      // Ensure start and length are present as strings if not provided
      queryParams.putIfAbsent('start', () => '0');
      queryParams.putIfAbsent('length', () => '1000');

      // Expand with common pagination synonyms to be robust against backend variations
      final start = queryParams['start'].toString();
      final length = queryParams['length'].toString();
      final int startInt = int.tryParse(start) ?? 0;
      final int lengthInt = int.tryParse(length) ?? 500;
      final int page = (lengthInt > 0) ? (startInt ~/ lengthInt) + 1 : 1;

      queryParams.addAll({
        'page': page,
        'per_page': length,
        'perPage': length,
        'pageSize': length,
        'page_size': length,
        'page_length': length,
        'pageLength': length,
        'limit_page_length': length,
        'limit_start': start,
        'limit': length,
        'offset': start,
        'count': length,
        'row_count': length,
        'size': length,
      });

      final resp = await client.get(
        '/order/getRecentOrders',
        queryParameters: queryParams,
      );
      final raw = resp.data;

      // helper to extract list from common envelope shapes
      List<Map<String, dynamic>> items = _extractList(raw);

      if (items.isEmpty && raw is Map && (raw['total'] != null || raw['recordsTotal'] != null)) {
         return [];
      }

      final List<OrderModel> models = [];
      for (final rawItem in items) {
        try {
          final normalized = _normalizeOrderJson(rawItem);
          models.add(OrderModel.fromJson(normalized));
        } catch (err) {
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

  // ── Normalization Helpers ──────────────────────────────────────────────────

  String? _asString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    if (v is num || v is bool) return v.toString();
    if (v is Map) {
      if (v.containsKey('name') && v['name'] is String) return v['name'] as String;
      if (v.containsKey('title') && v['title'] is String) return v['title'] as String;
    }
    return v.toString();
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    if (v is Map && v.containsKey('id')) return _asInt(v['id']);
    return null;
  }

  num? _asNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) return num.tryParse(v.replaceAll(',', ''));
    return null;
  }

  Map<String, dynamic>? _asMap(dynamic v) {
    if (v == null) return null;
    if (v is Map) return Map<String, dynamic>.from(v);
    return null;
  }

  List<Map<String, dynamic>> _asListOfMaps(dynamic v) {
    if (v == null) return <Map<String, dynamic>>[];
    if (v is List) {
      return v.map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList();
    }
    return <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _normalizeOrderJson(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);
    final stringFields = ['order_number', 'title', 'quotation', 'start_date', 'end_date', 'created_at', 'updated_at'];
    for (final f in stringFields) {
      if (out.containsKey(f)) out[f] = _asString(out[f]);
    }
    if (out.containsKey('id')) out['id'] = _asInt(out['id']);
    if (out.containsKey('customer_id')) out['customer_id'] = _asInt(out['customer_id']);
    if (out.containsKey('amount')) out['amount'] = _asNum(out['amount']);
    if (out.containsKey('payment_status')) out['payment_status'] = _asInt(out['payment_status']);

    out['customer'] = _asMap(out['customer']);
    out['user'] = _asMap(out['user']);
    out['status_row'] = _asMap(out['status_row']);
    out['payment_status_row'] = _asMap(out['payment_status_row']);

    final rawItems = _asListOfMaps(out['items']);
    final normalizedItems = <Map<String, dynamic>>[];
    for (final it in rawItems) {
      final m = Map<String, dynamic>.from(it);
      if (m.containsKey('order_id')) m['order_id'] = _asString(m['order_id']);
      if (m.containsKey('item_id')) m['item_id'] = _asString(m['item_id']);
      if (m.containsKey('price')) m['price'] = _asString(m['price']);
      if (m.containsKey('quantity')) m['quantity'] = _asString(m['quantity']);
      m['product'] = _asMap(m['product']);
      m['package_unit'] = _asMap(m['package_unit']);
      normalizedItems.add(m);
    }
    out['items'] = normalizedItems;

    final rawTrucks = _asListOfMaps(out['truck_list']);
    final normalizedTrucks = <Map<String, dynamic>>[];
    for (final t in rawTrucks) {
      final m = Map<String, dynamic>.from(t);
      if (m.containsKey('order_id')) m['order_id'] = _asString(m['order_id']);
      m['id'] = _asInt(m['id']);
      normalizedTrucks.add(m);
    }
    out['truck_list'] = normalizedTrucks;
    return out;
  }

  Map<String, dynamic> _normalizeProductJson(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);
    out['id'] = _asInt(src['id'] ?? src['uuid'] ?? src['product_id'] ?? src['item_id']);
    out['name'] = _asString(src['name'] ?? src['title'] ?? src['subject'] ?? src['label'] ?? src['item_name']);
    out['type'] = _asString(src['type'] ?? src['item_type']);
    out['item_type'] = _asString(src['item_type'] ?? src['type']);
    out['sale_price'] = _asString(src['sale_price'] ?? src['salePrice'] ?? src['price'] ?? src['rate']);
    out['purchase_price'] = _asString(src['purchase_price'] ?? src['purchasePrice']);
    out['item_number'] = _asString(src['item_number'] ?? src['sku'] ?? src['code'] ?? src['number']);
    out['category_id'] = _asInt(src['category_id']);
    return out;
  }

  Map<String, dynamic> _normalizePackageUnitJson(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);
    out['id'] = _asInt(src['id'] ?? src['unit_id']);
    out['name'] = _asString(src['name'] ?? src['unit_name'] ?? src['label'] ?? src['title']);
    out['short_name'] = _asString(src['short_name']);
    return out;
  }

  /// GET /sales/getSalesSettings
  Future<Map<String, dynamic>> getSalesSettings() async {
    final endpoints = ['/sales/getSalesSettings'];
    for (final path in endpoints) {
      try {
        final resp = await client.get(path);
        final raw = resp.data;
        Map<String, dynamic>? result;
        if (raw is Map) {
          if (raw['data'] is Map) {
            result = Map<String, dynamic>.from(raw['data'] as Map);
          } else if (raw.isNotEmpty) {
            result = Map<String, dynamic>.from(raw);
          }
        } else if (raw is String) {
          final s = raw.trim();
          if (!s.startsWith('<')) {
            try {
              final decoded = json.decode(s);
              if (decoded is Map) {
                result = decoded['data'] is Map
                    ? Map<String, dynamic>.from(decoded['data'] as Map)
                    : Map<String, dynamic>.from(decoded);
              }
            } catch (_) {}
          }
        }
        if (result != null && result.isNotEmpty) {
          return result;
        }
      } catch (_) {}
    }
    return <String, dynamic>{};
  }

  // ── Helper to extract list payloads ─────────────────────────────────────────
  List<Map<String, dynamic>> _extractList(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (raw is Map) {
      final possibleInners = ['data', 'payload', 'items', 'records', 'materials', 'products', 'units', 'statuses', 'settings', 'contracts', 'requests', 'quotations', 'currencies', 'exchange_rates', 'sale_order_requests', 'rates', 'currency', 'contract', 'request', 'form_numbers', 'pfi', 'order', 'status'];
      
      // 1. check direct keys
      for (final key in possibleInners) {
        if (raw[key] is List) {
          return (raw[key] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }

      // 2. handle nested pagination: { "data": { "data": [...] } }
      if (raw['data'] is Map) {
        final inner = raw['data'] as Map;
        for (final key in possibleInners) {
          if (inner[key] is List) {
            return (inner[key] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
          }
        }
      }

      // 3. handle { "payload": { "data": [...] } }
      if (raw['payload'] is Map) {
        final inner = raw['payload'] as Map;
        for (final key in possibleInners) {
          if (inner[key] is List) {
            return (inner[key] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
          }
        }
      }
    }
    if (raw is String) {
      final s = raw.trim();
      if (!s.startsWith('<')) {
        try {
          return _extractList(json.decode(s));
        } catch (_) {}
      }
    }
    return [];
  }

  /// GET /order/getOrderStatus
  Future<List<OrderStatusModel>> getOrderStatuses() async {
    try {
      final resp = await client.get('/order/getOrderStatus');
      return _extractList(resp.data).map((m) => OrderStatusModel.fromJson(m)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /product/getItem
  Future<List<ProductModel>> getProducts() async {
    final list = await getRawProducts();
    return list.map((m) => ProductModel.fromJson(m)).toList();
  }

  /// Internal helper to get raw product maps
  Future<List<Map<String, dynamic>>> getRawProducts({int? creatorId}) async {
    try {
      final resp = await client.get(
        '/product/getItem',
        queryParameters: {if (creatorId != null) 'creatorId': creatorId},
      );
      final list = _extractList(resp.data);
      return list.map((m) => _normalizeProductJson(m)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /product/getProductUnit
  Future<List<PackageUnitModel>> getPackageUnits({int? creatorId}) async {
    try {
      final resp = await client.get(
        '/product/getProductUnit',
        queryParameters: {if (creatorId != null) 'creatorId': creatorId},
      );
      return _extractList(resp.data)
          .map((m) => PackageUnitModel.fromJson(_normalizePackageUnitJson(m)))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /vehicle/getVehicle
  Future<List<Map<String, dynamic>>> getVehicles() async {
    try {
      final resp = await client.get('/vehicle/getVehicle');
      return _extractList(resp.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getPackageTypes() async {
    try {
      final resp = await client.get('/order/getPackageType');
      return _extractList(resp.data);
    } catch (_) { return []; }
  }

  Future<List<Map<String, dynamic>>> getWarehouses() async {
    try {
      final resp = await client.get('/warehouse/getWarehouse');
      return _extractList(resp.data);
    } catch (_) { return []; }
  }

  Future<List<Map<String, dynamic>>> getQuotations() async {
    try {
      final resp = await client.get('/sales/getSaleOrderPFI');
      return _extractList(resp.data);
    } catch (_) { return []; }
  }

  Future<List<Map<String, dynamic>>> getContracts() async {
    try {
      final resp = await client.get('/contract/getSaleOrderContract');
      return _extractList(resp.data);
    } catch (_) { return []; }
  }

  Future<List<Map<String, dynamic>>> getRequests() async {
    try {
      final resp = await client.get('/sales/getSaleOrderRequest');
      return _extractList(resp.data);
    } catch (_) { return []; }
  }

  Future<List<Map<String, dynamic>>> getTaxes() async {
    try {
      final resp = await client.get('/sales/getTaxes');
      return _extractList(resp.data);
    } catch (_) { return []; }
  }

  Future<List<Map<String, dynamic>>> getCurrencies() async {
    try {
      final resp = await client.get('/logistic/getCurrency');
      return _extractList(resp.data);
    } catch (_) { return []; }
  }
  
  Future<double?> getExchangeRate(int currencyId) async {
    try {
      final resp = await client.get('/logistic/getExchangeRate/$currencyId');
      final raw = resp.data;
      if (raw is Map && raw.containsKey('rate')) {
        return double.tryParse(raw['rate'].toString());
      } else if (raw is num) {
        return raw.toDouble();
      } else if (raw is String) {
        final decoded = json.decode(raw);
        if (decoded is Map && decoded.containsKey('rate')) return double.tryParse(decoded['rate'].toString());
      }
    } catch (_) {}
    return null;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final resp = await client.get('/user/getUsers');
      return _extractList(resp.data);
    } catch (_) { return []; }
  }

  /// POST /order/saveOrder
  Future<Map<String, dynamic>> saveOrder(Map<String, dynamic> payload) async {
    try {
      final resp = await client.post('/order/saveOrder', data: payload);
      final raw = resp.data;
      if (raw is Map) return Map<String, dynamic>.from(raw);
      if (raw is String) {
        final s = raw.trim();
        if (!s.startsWith('<')) {
          try {
            final decoded = json.decode(s);
            if (decoded is Map) return Map<String, dynamic>.from(decoded);
          } catch (_) {}
        }
      }
      return {'status': 200};
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
