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

  /// GET /order/getSaleOrder
  Future<List<OrderModel>> getRecentOrders([
    Map<String, dynamic>? params,
  ]) async {
    try {
      final defaultStatus = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

      final defaultData = <String, dynamic>{
        'draw': '1',
        'start': '0',
        'length': '1000',
        'search[value]': '',
        'search[regex]': 'false',
        'start_date': '2000-01-01',
        'end_date': '2100-12-31 23:59:59',
        'user': 'All',
        'customer': 'All',
        'vehicle': 'All',
        'pickup': 'All',
        'delivery': 'All',
        'departure': 'All',
      };

      final queryParams = params != null
          ? Map<String, dynamic>.from(params)
          : Map<String, dynamic>.from(defaultData);

      // Robust pagination parameters (mirroring Jobcard implementation for compatibility)
      final lengthVal = queryParams['length'] ?? '1000';
      final startVal = queryParams['start'] ?? '0';

      queryParams['length'] = lengthVal;
      queryParams['limit'] = lengthVal;
      queryParams['per_page'] = lengthVal;
      queryParams['page_length'] = lengthVal;
      queryParams['limit_page_length'] = lengthVal;
      queryParams['all'] = '1';

      queryParams['start'] = startVal;
      queryParams['offset'] = startVal;
      queryParams['limit_start'] = startVal;

      // Handle search parameters
      final searchObj = queryParams['search'];
      if (searchObj is Map) {
        queryParams.putIfAbsent('search[value]', () => searchObj['value'] ?? '');
        queryParams.putIfAbsent('search[regex]', () => searchObj['regex'] ?? 'false');
      } else if (!queryParams.containsKey('search[value]')) {
        queryParams['search[value]'] = '';
        queryParams['search[regex]'] = 'false';
      }

      final resp = await client.get(
        '/order/getSaleOrder',
        queryParameters: queryParams,
      );
      final raw = resp.data;

      // helper to extract list from common envelope shapes
      List<Map<String, dynamic>> items = _extractList(raw);

      if (items.isEmpty &&
          raw is Map &&
          (raw['total'] != null || raw['recordsTotal'] != null)) {
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
      if (v.containsKey('name') && v['name'] is String)
        return v['name'] as String;
      if (v.containsKey('title') && v['title'] is String)
        return v['title'] as String;
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
      return v
          .map(
            (e) =>
                e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{},
          )
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  String _parseHtmlToReadable(String html) {
    var s = html;
    s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'</(p|div)>', caseSensitive: false), '\n\n');
    s = s.replaceAll(RegExp(r'</li>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'<li>', caseSensitive: false), '• ');
    s = s.replaceAll(RegExp(r'&nbsp;', caseSensitive: false), ' ');
    s = s.replaceAll(RegExp(r'&amp;', caseSensitive: false), '&');
    s = s.replaceAll(RegExp(r'&lt;', caseSensitive: false), '<');
    s = s.replaceAll(RegExp(r'&gt;', caseSensitive: false), '>');
    s = s.replaceAll(RegExp(r'&quot;', caseSensitive: false), '"');
    s = s.replaceAll(RegExp(r'<[^>]*>'), '');
    s = s.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return s.trim();
  }

  Map<String, dynamic> _normalizeOrderJson(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);
    final stringFields = [
      'order_number',
      'title',
      'start_date',
      'end_date',
      'created_at',
      'updated_at',
    ];
    for (final f in stringFields) {
      if (out.containsKey(f)) out[f] = _asString(out[f]);
    }

    // Strip HTML tags from order_number (API sometimes returns it wrapped in <a> tags)
    if (out.containsKey('order_number') && out['order_number'] is String) {
      out['order_number'] = (out['order_number'] as String)
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll(RegExp(r'&[^;]+;'), '')
          .trim();
    }

    if (out.containsKey('quotation')) {
      final qStr = _asString(out['quotation']);
      if (qStr != null) out['quotation'] = _parseHtmlToReadable(qStr);
    }
    if (out.containsKey('id')) out['id'] = _asInt(out['id']);
    if (out.containsKey('customer_id'))
      out['customer_id'] = _asInt(out['customer_id']);
    if (out.containsKey('amount')) out['amount'] = _asNum(out['amount']);
    if (out.containsKey('payment_status'))
      out['payment_status'] = _asInt(out['payment_status']);

    Map<String, dynamic>? fixId(Map<String, dynamic>? m) {
      if (m == null) return null;
      if (m.containsKey('id')) m['id'] = _asInt(m['id']);
      if (m.containsKey('name')) {
        final n = _asString(m['name']);
        if (n != null) {
          m['name'] = n.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
        }
      }
      return m;
    }

    // Safely extract status_row or fallback to 'status' string if it contains HTML
    var sRow = _asMap(out['status_row']);
    if (sRow == null && out.containsKey('status') && out['status'] is String) {
      final statStr = out['status'] as String;
      final stripped = statStr.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
      if (stripped.isNotEmpty) {
        // optionally try to extract color if present
        String? color;
        final colorMatch = RegExp(r'color:\s*(#[a-fA-F0-9]+)').firstMatch(statStr);
        final bgMatch = RegExp(r'background-color:\s*(#[a-fA-F0-9]+)').firstMatch(statStr);
        if (bgMatch != null) color = bgMatch.group(1);
        else if (colorMatch != null) color = colorMatch.group(1);
        sRow = {'name': stripped, 'color': color};
      }
    }
    out['status_row'] = fixId(sRow);
    out['payment_status_row'] = fixId(_asMap(out['payment_status_row']));

    final rawItems = _asListOfMaps(out['items']);
    final normalizedItems = <Map<String, dynamic>>[];
    for (final it in rawItems) {
      final m = Map<String, dynamic>.from(it);
      if (m.containsKey('id')) m['id'] = _asInt(m['id']);
      if (m.containsKey('order_id')) m['order_id'] = _asString(m['order_id']);
      if (m.containsKey('item_id')) m['item_id'] = _asString(m['item_id']);
      if (m.containsKey('price')) m['price'] = _asString(m['price']);
      if (m.containsKey('quantity')) m['quantity'] = _asString(m['quantity']);
      if (m.containsKey('loading_instruction')) {
        final li = _asString(m['loading_instruction']);
        if (li != null) m['loading_instruction'] = _parseHtmlToReadable(li);
      }
      
      final pMap = _asMap(m['product']);
      m['product'] = pMap != null ? _normalizeProductJson(pMap) : null;
      
      final puMap = _asMap(m['package_unit']);
      m['package_unit'] = puMap != null ? _normalizePackageUnitJson(puMap) : null;
      
      normalizedItems.add(m);
    }
    out['items'] = normalizedItems;

    final rawTrucks = _asListOfMaps(out['truck_list']);
    final normalizedTrucks = <Map<String, dynamic>>[];
    for (final t in rawTrucks) {
      final m = Map<String, dynamic>.from(t);
      if (m.containsKey('order_id')) m['order_id'] = _asString(m['order_id']);
      if (m.containsKey('id')) m['id'] = _asInt(m['id']);
      normalizedTrucks.add(m);
    }
    out['truck_list'] = normalizedTrucks;
    return out;
  }

  Map<String, dynamic> _normalizeProductJson(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);
    out['id'] = _asInt(
      src['id'] ?? src['uuid'] ?? src['product_id'] ?? src['item_id'],
    );
    out['name'] = _asString(
      src['name'] ??
          src['title'] ??
          src['subject'] ??
          src['label'] ??
          src['item_name'],
    );
    out['type'] = _asString(src['type'] ?? src['item_type']);
    out['item_type'] = _asString(src['item_type'] ?? src['type']);
    out['sale_price'] = _asString(
      src['sale_price'] ?? src['salePrice'] ?? src['price'] ?? src['rate'],
    );
    out['purchase_price'] = _asString(
      src['purchase_price'] ?? src['purchasePrice'],
    );
    out['item_number'] = _asString(
      src['item_number'] ?? src['sku'] ?? src['code'] ?? src['number'],
    );
    out['category_id'] = _asInt(src['category_id']);

    // Improved unit and tax normalization
    final rawUnit =
        src['unit'] ??
        src['uom'] ??
        src['package_unit'] ??
        src['measurement_unit'];
    if (rawUnit is Map) {
      out['unit_id'] = _asInt(
        rawUnit['id'] ??
            rawUnit['uuid'] ??
            rawUnit['unit_id'] ??
            src['unit_id'] ??
            src['uom_id'],
      );
      out['unit_name'] = _asString(
        rawUnit['name'] ??
            rawUnit['title'] ??
            rawUnit['short_name'] ??
            rawUnit['unit_name'] ??
            rawUnit['unit'] ??
            rawUnit['uom'] ??
            src['unit_name'] ??
            src['unit'],
      );
    } else {
      out['unit_id'] = _asInt(src['unit_id'] ?? src['uom_id']);
      out['unit_name'] = _asString(
        src['unit_name'] ?? src['unit'] ?? src['uom'],
      );
    }

    final rawTax = src['tax'] ?? src['tax_rate'] ?? src['tax_row'];
    if (rawTax is Map) {
      out['tax_id'] = _asInt(
        rawTax['id'] ??
            rawTax['tax_id'] ??
            rawTax['tax_rate_id'] ??
            src['tax_id'] ??
            src['tax_rate_id'],
      );
      out['tax_name'] = _asString(
        rawTax['name'] ??
            rawTax['title'] ??
            rawTax['tax_name'] ??
            rawTax['tax_label'] ??
            rawTax['rate'] ??
            src['tax_name'] ??
            src['tax'],
      );
    } else {
      out['tax_id'] = _asInt(src['tax_id'] ?? src['tax_rate_id']);
      out['tax_name'] = _asString(
        src['tax_name'] ?? src['tax'] ?? src['tax_label'],
      );
    }

    return out;
  }

  Map<String, dynamic> _normalizePackageUnitJson(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);
    out['id'] = _asInt(src['id'] ?? src['unit_id']);
    out['name'] = _asString(
      src['name'] ?? src['unit_name'] ?? src['label'] ?? src['title'],
    );
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
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (raw is Map) {
      final possibleInners = [
        'data',
        'payload',
        'items',
        'records',
        'materials',
        'products',
        'units',
        'unit',
        'statuses',
        'settings',
        'contracts',
        'contract',
        'requests',
        'request',
        'quotations',
        'quotation',
        'currencies',
        'currency',
        'currency_list',
        'currency_data',
        'exchange_rates',
        'sale_order_requests',
        'rates',
        'form_numbers',
        'pfi',
        'order',
        'status',
        'tickets',
        'support_tickets',
        'jobcards',
        'warehouses',
        'warehouse',
        'users',
        'user',
        'taxes',
        'tax',
        'projects',
        'project',
        'trips',
        'trip',
        'payment_terms',
        'payment_term',
        'payment_methods',
        'payment_method',
        'vehicles',
        'vehicle',
        'package_types',
        'package_type',
        'measure_units',
      ];

      // 1. check direct keys
      for (final key in possibleInners) {
        if (raw[key] is List) {
          return (raw[key] as List)
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      }

      // 2. handle nested pagination: { "data": { "data": [...] } }
      if (raw['data'] is Map) {
        final inner = raw['data'] as Map;
        for (final key in possibleInners) {
          if (inner[key] is List) {
            return (inner[key] as List)
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          }
        }
      }

      // 3. handle { "payload": { "data": [...] } }
      if (raw['payload'] is Map) {
        final inner = raw['payload'] as Map;
        for (final key in possibleInners) {
          if (inner[key] is List) {
            return (inner[key] as List)
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
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
      return _extractList(
        resp.data,
      ).map((m) => OrderStatusModel.fromJson(m)).toList();
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
        queryParameters: {
          if (creatorId != null) 'creatorId': creatorId,
          'length': '1000',
          'limit': '1000',
          'per_page': '1000',
          'all': '1',
        },
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
        queryParameters: {
          if (creatorId != null) 'creatorId': creatorId,
          'length': '1000',
          'limit': '1000',
          'per_page': '1000',
          'all': '1',
        },
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
      final resp = await client.get('/vehicle/getVehicle', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getPackageTypes() async {
    try {
      final resp = await client.get('/order/getPackageType', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getWarehouses() async {
    try {
      final resp = await client.get('/warehouse/getWarehouse', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getQuotations() async {
    try {
      final resp = await client.get('/sales/getSaleOrderPFI', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getContracts() async {
    try {
      final resp = await client.get('/contract/getSaleOrderContract', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRequests() async {
    try {
      final resp = await client.get('/sales/getSaleOrderRequest', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTaxes() async {
    try {
      final resp = await client.get('/sales/getTaxes', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProjects() async {
    final paths = [
      '/project/getProject',
      '/projects/getProject',
      '/get-projects',
      '/sales/getProject',
    ];
    for (final p in paths) {
      try {
        final resp = await client.get(p, queryParameters: {
          'length': '1000',
          'limit': '1000',
          'per_page': '1000',
          'all': '1',
        });
        final list = _extractList(resp.data);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getTrips() async {
    final paths = [
      '/trip/getTrip',
      '/trips/getTrip',
      '/logistic/getTrip',
    ];
    for (final p in paths) {
      try {
        final resp = await client.get(p, queryParameters: {
          'length': '1000',
          'limit': '1000',
          'per_page': '1000',
          'all': '1',
        });
        final list = _extractList(resp.data);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getPaymentTerms() async {
    final paths = [
      '/payment/getPaymentTerm',
      '/sales/getPaymentTerm',
      '/order/getPaymentTerm',
    ];
    for (final p in paths) {
      try {
        final resp = await client.get(p, queryParameters: {
          'length': '1000',
          'limit': '1000',
          'per_page': '1000',
          'all': '1',
        });
        final list = _extractList(resp.data);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final paths = [
      '/payment/getPaymentMethod',
      '/sales/getPaymentMethod',
      '/order/getPaymentMethod',
    ];
    for (final p in paths) {
      try {
        final resp = await client.get(p, queryParameters: {
          'length': '1000',
          'limit': '1000',
          'per_page': '1000',
          'all': '1',
        });
        final list = _extractList(resp.data);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getCurrencies() async {
    final paths = [
      '/order/getCurrency',
      '/logistic/getCurrency',
      '/sales/getCurrency',
      '/api/getCurrency',
      '/currency/getCurrency',
    ];
    for (final p in paths) {
      try {
        final list = await _getMetadata(p);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<double?> getExchangeRate(int currencyId) async {
    final paths = [
      '/logistic/getExchangeRate/$currencyId',
      '/order/getExchangeRate/$currencyId',
      '/sales/getExchangeRate/$currencyId',
      '/api/getExchangeRate/$currencyId',
    ];
    for (final p in paths) {
      try {
        final resp = await client.get(p);
        final raw = resp.data;
        if (raw is Map && raw.containsKey('rate')) {
          return double.tryParse(raw['rate'].toString());
        } else if (raw is num) {
          return raw.toDouble();
        } else if (raw is String) {
          final decoded = json.decode(raw);
          if (decoded is Map && decoded.containsKey('rate'))
            return double.tryParse(decoded['rate'].toString());
        }
      } catch (_) {}
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getPriorities() async {
    final paths = [
      '/order/getPriority',
      '/support/getSupportPriority',
      '/order/getPriorities',
      '/sales/getPriority'
    ];
    for (final p in paths) {
      try {
        final list = await _getMetadata(p);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getCargoUnits() async {
    final paths = [
      '/product/getProductUnit',
      '/order/getMeasureUnits',
      '/sales/getMeasureUnit',
      '/logistic/getMeasureUnits'
    ];
    for (final p in paths) {
      try {
        final list = await _getMetadata(p);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getPaymentTypes() async {
    final paths = [
      '/order/getPackageType',
      '/sales/getPaymentType',
      '/api/payment/getPaymentType',
      '/order/getPaymentType'
    ];
    for (final p in paths) {
      try {
        final list = await _getMetadata(p);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getDiscountTypes() async {
    final paths = [
      '/sales/getDiscountType',
      '/order/getDiscountType',
      '/proposal/getDiscountType',
    ];
    for (final p in paths) {
      try {
        final list = await _getMetadata(p);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getSubscriptionDurations() async {
    try {
      return await _getMetadata('/sales/getSubscriptionDuration');
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final paths = [
      '/user/getUsers',
      '/users/getUsers',
      '/auth/getUsers',
    ];
    for (final p in paths) {
      try {
        final list = await _getMetadata(p);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getSupportTickets() async {
    return _getMetadata('/support/getSupportTicket');
  }

  Future<List<Map<String, dynamic>>> getJobCards() async {
    final paths = [
      '/jobcard/getJobCard',
      '/job-card/getJobCard',
      '/sales/getJobCard',
    ];
    for (final p in paths) {
      try {
        final list = await _getMetadata(p);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> _getMetadata(String path) async {
    try {
      final resp = await client.get(
        path,
        queryParameters: {
          'length': '1000',
          'limit': '1000',
          'per_page': '1000',
          'page_length': '1000',
          'all': '1',
          'draw': '1',
          'start': '0',
        },
      );
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  /// POST /order/saveOrder
  Future<Map<String, dynamic>> saveOrder(dynamic payload) async {
    try {
      final resp = await client.post('/order/saveOrder', data: payload);
      final raw = resp.data;
      if (raw is Map) return Map<String, dynamic>.from(raw);
      return {'status': 200};
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Map<String, dynamic>> savePfi(dynamic payload) async {
    try {
      final resp = await client.post('/proposal/saveSalesQuotation', data: payload);
      final raw = resp.data;
      if (raw is Map) return Map<String, dynamic>.from(raw);
      return {'status': 200};
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
