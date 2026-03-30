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
    
    // 1. Broad set of fields that must be strings in OrderModel
    final stringFields = [
      'order_number', 'invoice_number', 'title', 'start_date', 'end_date',
      'created_at', 'updated_at', 'lpo_number', 'sender_name', 'sender_phone',
      'receiver_name', 'receiver_phone', 'consignment_details', 'package_type',
      'cargo_value', 'cargo_unit', 'priority', 'payment_type', 
      'currency_id', 'exchange_rate', 'contract_id', 'request_id', 'quotation_id',
      'duration', 'duration_unit'
    ];
    for (final f in stringFields) {
      if (out.containsKey(f)) out[f] = _asString(out[f]);
    }

    if (out.containsKey('order_number') && out['order_number'] is String) {
      out['order_number'] = (out['order_number'] as String)
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll(RegExp(r'&[^;]+;'), '')
          .trim();
    }

    // Attempt to extract invoice number from various possible keys if not explicit
    out['invoice_number'] = _asString(
      out['invoice_number'] ?? 
      out['invoice_no'] ?? 
      out['inv_no'] ?? 
      out['ref_no'] ?? 
      out['invoice']
    );

    if (out.containsKey('quotation')) {
      final qStr = _asString(out['quotation']);
      if (qStr != null) out['quotation'] = _parseHtmlToReadable(qStr);
    }
    
    // 2. Normalize common integer IDs
    final intFields = [
      'id', 'customer_id', 'customerId', 'warehouse_id', 'status_id', 
      'assign_user_id', 'payment_status'
    ];
    for (final f in intFields) {
      if (out.containsKey(f)) {
        final val = _asInt(out[f]);
        if (f == 'customerId') out['customer_id'] = val;
        else out[f] = val;
      }
    }

    if (out.containsKey('amount')) out['amount'] = _asNum(out['amount']);

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

    // 3. Normalize nested objects
    var sRow = _asMap(out['status_row']);
    if (sRow == null && out.containsKey('status') && out['status'] is String) {
      final statStr = out['status'] as String;
      final stripped = statStr.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
      if (stripped.isNotEmpty) {
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
    
    // Robustly normalize customer and user if present as maps
    if (out['customer'] is Map) {
      final c = Map<String, dynamic>.from(out['customer'] as Map);
      if (c.containsKey('id')) c['id'] = _asInt(c['id']);
      if (c.containsKey('name')) c['name'] = _asString(c['name']);
      if (c.containsKey('email')) c['email'] = _asString(c['email']);
      if (c.containsKey('contact')) c['contact'] = _asString(c['contact']);
      out['customer'] = c;
    }
    
    if (out['user'] is Map) {
      final u = Map<String, dynamic>.from(out['user'] as Map);
      if (u.containsKey('id')) u['id'] = _asInt(u['id']);
      if (u.containsKey('name')) u['name'] = _asString(u['name']);
      if (u.containsKey('email')) u['email'] = _asString(u['email']);
      if (u.containsKey('phone')) u['phone'] = _asString(u['phone']);
      out['user'] = u;
    }

    // 4. Normalize Order Items
    final rawItems = _asListOfMaps(out['items']);
    final normalizedItems = <Map<String, dynamic>>[];
    for (final it in rawItems) {
      final m = Map<String, dynamic>.from(it);
      if (m.containsKey('id')) m['id'] = _asInt(m['id']);
      
      final itemStringFields = [
        'order_id', 'item_id', 'price', 'quantity', 'tax', 'discount', 
        'duration', 'duration_unit'
      ];
      for (final f in itemStringFields) {
        if (m.containsKey(f)) m[f] = _asString(m[f]);
      }
      
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

    // 5. Normalize Truck List
    final rawTrucks = _asListOfMaps(out['truck_list']);
    final normalizedTrucks = <Map<String, dynamic>>[];
    for (final t in rawTrucks) {
      final m = Map<String, dynamic>.from(t);
      if (m.containsKey('id')) m['id'] = _asInt(m['id']);
      if (m.containsKey('order_id')) m['order_id'] = _asString(m['order_id']);
      if (m.containsKey('vehicle_id')) m['vehicle_id'] = _asInt(m['vehicle_id']);
      
      final truckStringFields = [
        'vehicle_name', 'vehicle_plate_number', 'vehicle_trailer_number',
        'driver_name', 'driver_phone', 'driver_license_number',
        'checkin_status', 'checkout_status', 'checkin_datetime', 'checkout_datetime',
        'checkin_weight', 'checkin_weight_unit', 'checkout_weight', 'checkout_weight_unit',
        'net_weight', 'net_weight_unit'
      ];
      for (final f in truckStringFields) {
        if (m.containsKey(f)) m[f] = _asString(m[f]);
      }
      
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
        'products_data',
        'items_data',
        'product_list',
        'material_list',
        'item_list',
        'services',
        'service',
        'inventory',
        'inventory_items',
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
        'jobcard',
        'job_cards',
        'job_card',
        'job-cards',
        'job-card',
        'warehouses',
        'warehouse',
        'users',
        'user',
        'taxes',
        'tax',
        'projects',
        'project',
        'project_list',
        'trips',
        'trip',
        'trip_list',
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
      final params = creatorId != null ? {'creatorId': creatorId} : null;
      final paths = [
        '/product/getItem',
        '/product/getMaterial',
        '/product/getProducts',
        '/material/getMaterial',
        '/logistic/getMaterial',
        '/inventory/getItem',
        '/sales/getMaterial',
        '/sales/getItem',
        '/api/product/getItem',
        '/api/sales/getMaterial',
      ];
      
      for (final p in paths) {
        // Try simple fetch first (high limit, no complex pagination keys)
        var list = await _getMetadataSimple(p, params: params);
        if (list.isNotEmpty) return list.map((m) => _normalizeProductJson(m)).toList();
        
        // Fallback to complex paginated fetch
        list = await _getMetadata(p, params: params);
        if (list.isNotEmpty) return list.map((m) => _normalizeProductJson(m)).toList();
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> _getMetadataSimple(String path, {Map<String, dynamic>? params}) async {
    try {
      final queryParams = <String, dynamic>{
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      };
      if (params != null) queryParams.addAll(params);
      
      final resp = await client.get(path, queryParameters: queryParams);
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  /// GET /product/getProductUnit
  Future<List<PackageUnitModel>> getPackageUnits({int? creatorId}) async {
    try {
      final params = creatorId != null ? {'creatorId': creatorId} : null;
      final paths = [
        '/product/getProductUnit',
        '/sales/getMeasureUnit',
        '/order/getMeasureUnits',
        '/logistic/getMeasureUnits',
        '/api/product/getProductUnit',
        '/api/sales/getMeasureUnit',
      ];
      
      for (final p in paths) {
        var list = await _getMetadataSimple(p, params: params);
        if (list.isEmpty) {
          list = await _getMetadata(p, params: params);
        }
        if (list.isNotEmpty) {
          return list
              .map((m) => PackageUnitModel.fromJson(_normalizePackageUnitJson(m)))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /vehicle/getVehicle
  Future<List<Map<String, dynamic>>> getVehicles() async {
    return _getMetadata('/vehicle/getVehicle');
  }

  Future<List<Map<String, dynamic>>> getPackageTypes() async {
    return _getMetadata('/order/getPackageType');
  }

  Future<List<Map<String, dynamic>>> getWarehouses() async {
    return _getMetadata('/warehouse/getWarehouse');
  }

  Future<List<Map<String, dynamic>>> getQuotations() async {
    return _getMetadata('/sales/getSaleOrderPFI');
  }

  Future<List<Map<String, dynamic>>> getContracts() async {
    return _getMetadata('/contract/getSaleOrderContract');
  }

  Future<List<Map<String, dynamic>>> getRequests() async {
    return _getMetadata('/sales/getSaleOrderRequest');
  }

  Future<List<Map<String, dynamic>>> getTaxes() async {
    return _getMetadata('/sales/getTaxes');
  }

  Future<List<Map<String, dynamic>>> getProjects() async {
    final paths = [
      '/get-projects',
      '/proposal/getProject',
      '/project/getProject',
      '/sales/getProject',
    ];
    for (final p in paths) {
      try {
        final list = await _getMetadata(p);
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
        final list = await _getMetadata(p);
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
        final list = await _getMetadata(p);
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
        final list = await _getMetadata(p);
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getCurrencies() async {
    final paths = [
      '/proposal/getCurrency',
      '/currency/getCurrency',
      '/api/getCurrency',
      '/order/getCurrency',
      '/sales/getCurrency',
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
      '/sales/getSalesAgent',
      '/sales/getSalesAgents',
      '/auth/getUsers',
      '/users/getUsers',
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

  Future<List<Map<String, dynamic>>> _getMetadata(String path, {Map<String, dynamic>? params}) async {
    try {
      final List<Map<String, dynamic>> allItems = [];
      int currentPage = 1;
      int lastPage = 1;
      const int pageSize = 1000; 

      do {
        final queryParams = <String, dynamic>{
          'page': currentPage,
          'length': pageSize.toString(),
          'limit': pageSize.toString(),
          'per_page': pageSize.toString(),
          'page_length': pageSize.toString(),
          'limit_page_length': pageSize.toString(),
          'all': '1',
          'draw': '1',
          'start': (currentPage - 1) * pageSize,
          'offset': (currentPage - 1) * pageSize,
        };
        if (params != null) {
          queryParams.addAll(params);
        }

        final resp = await client.get(
          path,
          queryParameters: queryParams,
          options: Options(
            validateStatus: (s) => s != null && s < 500,
            sendTimeout: const Duration(seconds: 4),
            receiveTimeout: const Duration(seconds: 8),
          ),
        ).timeout(const Duration(seconds: 10));

        if (resp.statusCode != 200) break;

        final raw = resp.data;
        final pageItems = _extractList(raw);
        if (pageItems.isEmpty) break;

        allItems.addAll(pageItems);

        // Robust pagination metadata detection
        if (raw is Map) {
          final paginator = raw['data'] is Map
              ? raw['data'] as Map
              : (raw['payload'] is Map ? raw['payload'] as Map : raw);

          final lp = paginator['last_page'] ??
              paginator['lastPage'] ??
              paginator['total_pages'] ??
              paginator['totalPages'] ??
              raw['total_pages'] ??
              raw['last_page'];

          if (lp is num) {
            lastPage = lp.toInt();
          } else if (lp is String) {
            lastPage = int.tryParse(lp) ?? 1;
          } else {
            final totalRaw = paginator['total'] ??
                paginator['recordsTotal'] ??
                paginator['records_total'] ??
                raw['total'] ??
                raw['recordsTotal'] ??
                raw['records_total'];

            final perPageRaw = paginator['per_page'] ??
                paginator['perPage'] ??
                paginator['limit'] ??
                raw['per_page'] ??
                raw['limit'] ??
                pageSize;

            int? total;
            if (totalRaw is num) total = totalRaw.toInt();
            else if (totalRaw is String) total = int.tryParse(totalRaw);

            int? perPage;
            if (perPageRaw is num) perPage = perPageRaw.toInt();
            else if (perPageRaw is String) perPage = int.tryParse(perPageRaw);

            if (total != null && perPage != null && perPage > 0) {
              lastPage = (total / perPage).ceil();
            } else {
              // OPTIMISTIC FALLBACK: If we got items but no metadata, 
              // try to fetch the next page regardless until we get empty list or hit cap.
              if (pageItems.length > 0) {
                lastPage = currentPage + 1;
              } else {
                lastPage = 1;
              }
            }
          }
        } else {
          lastPage = 1;
        }

        currentPage++;
      } while (currentPage <= lastPage && lastPage > 1 && allItems.length < 10000);

      return allItems;
    } catch (e) {
      // ignore: avoid_print
      print('[SalesDataSource] _getMetadata error for $path: $e');
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

  /// GET /generateUniqueNumber?table={table}&column={column}
  /// Returns a generated number as a string when available.
  Future<String?> generateUniqueNumber(String table, String column) async {
    try {
      final resp = await client.get(
        '/generateUniqueNumber',
        queryParameters: {
          'table': table,
          'column': column,
        },
        options: Options(extra: {'noAuth': true}),
      );
      return _tryParseNextNumber(resp.data);
    } catch (e) {
      // ignore: avoid_print
      print('[SalesRemoteDataSource] generateUniqueNumber error for $table: $e');
      return null;
    }
  }

  String? _tryParseNextNumber(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) {
      final s = raw.trim();
      if (s.isEmpty || s.startsWith('<')) return null;
      try {
        final decoded = json.decode(s);
        return _tryParseNextNumber(decoded);
      } catch (_) {
        return s;
      }
    }
    if (raw is Map) {
      if (raw['data'] is String) return raw['data'] as String;
      if (raw['data'] is Map && raw['data']['number'] != null)
        return raw['data']['number'].toString();
      if (raw['number'] != null) return raw['number'].toString();
      if (raw['order_number'] != null) return raw['order_number'].toString();
      if (raw['proposal_number'] != null) return raw['proposal_number'].toString();
      for (final v in raw.values) {
        if (v is String && v.isNotEmpty) return v;
      }
    }
    if (raw is num) return raw.toString();
    return null;
  }
}
