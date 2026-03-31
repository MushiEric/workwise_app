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

      final now = DateTime.now();
      final today =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final defaultData = <String, dynamic>{
        'draw': '1',
        'start': '0',
        'length': '5000',
        'start_date': today,
        'end_date': today,
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

      queryParams.putIfAbsent('start', () => '0');
      queryParams.putIfAbsent('length', () => '5000');
      queryParams.putIfAbsent('start_date', () => today);
      queryParams.putIfAbsent('end_date', () => today);

      // Include status array if not already provided.
      if (!queryParams.containsKey('status') &&
          !queryParams.containsKey('status[]')) {
        queryParams['status[]'] = defaultStatus;
      }

      // Support both forms in case query has status=.. or status[]=..
      if (queryParams.containsKey('status') &&
          !queryParams.containsKey('status[]')) {
        queryParams['status[]'] = queryParams['status'];
      }

      // Also send flat search keys alongside any nested search object so
      // the server accepts either format.
      if (queryParams.containsKey('search[value]')) {
        queryParams.putIfAbsent('search[regex]', () => 'false');
      } else if (queryParams.containsKey('search')) {
        final searchObj = queryParams['search'];
        if (searchObj is Map) {
          queryParams.putIfAbsent(
            'search[value]',
            () => searchObj['value'] ?? '',
          );
          queryParams.putIfAbsent(
            'search[regex]',
            () => searchObj['regex'] ?? 'false',
          );
        }
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
      if (v.containsKey('name') && v['name'] is String) {
        return v['name'] as String;
      }
      if (v.containsKey('title') && v['title'] is String) {
        return v['title'] as String;
      }
    }
    return v.toString();
  }

  String? _stripHtml(String? value) {
    if (value == null) return null;
    final stripped = value.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    return stripped.isEmpty ? null : stripped;
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
      'order_number',
      'invoice_number',
      'status',
      'title',
      'start_date',
      'end_date',
      'created_at',
      'updated_at',
      'lpo_number',
      'sender_name',
      'sender_phone',
      'receiver_name',
      'receiver_phone',
      'consignment_details',
      'package_type',
      'cargo_value',
      'cargo_unit',
      'priority',
      'payment_type',
      'currency_id',
      'exchange_rate',
      'contract_id',
      'request_id',
      'quotation_id',
      'duration',
      'duration_unit',
    ];
    for (final f in stringFields) {
      if (out.containsKey(f)) out[f] = _asString(out[f]);
    }
    if (out.containsKey('id')) out['id'] = _asInt(out['id']);
    if (out.containsKey('customer_id')) {
      out['customer_id'] = _asInt(out['customer_id']);
    }
    if (out.containsKey('warehouse_id')) {
      out['warehouse_id'] = _asInt(out['warehouse_id']);
    }
    if (out.containsKey('status_id')) {
      out['status_id'] = _asInt(out['status_id']);
    }
    if (out.containsKey('assign_user_id')) {
      out['assign_user_id'] = _asInt(out['assign_user_id']);
    }
    if (out.containsKey('amount')) out['amount'] = _asNum(out['amount']);
    if (out.containsKey('payment_status')) {
      out['payment_status'] = _asInt(out['payment_status']);
    }

    if (out.containsKey('status')) {
      out['status'] = _stripHtml(_asString(out['status']));
    }
    if (out.containsKey('order_number')) {
      out['order_number'] = _stripHtml(_asString(out['order_number']));
    }

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
      final stripped = statStr
          .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')
          .trim();
      if (stripped.isNotEmpty) {
        String? color;
        final colorMatch = RegExp(
          r'color:\s*(#[a-fA-F0-9]+)',
        ).firstMatch(statStr);
        final bgMatch = RegExp(
          r'background-color:\s*(#[a-fA-F0-9]+)',
        ).firstMatch(statStr);
        if (bgMatch != null)
          color = bgMatch.group(1);
        else if (colorMatch != null)
          color = colorMatch.group(1);
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
        'order_id',
        'item_id',
        'price',
        'quantity',
        'tax',
        'discount',
        'duration',
        'duration_unit',
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
      m['package_unit'] = puMap != null
          ? _normalizePackageUnitJson(puMap)
          : null;

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
      if (m.containsKey('vehicle_id'))
        m['vehicle_id'] = _asInt(m['vehicle_id']);

      final truckStringFields = [
        'vehicle_name',
        'vehicle_plate_number',
        'vehicle_trailer_number',
        'driver_name',
        'driver_phone',
        'driver_license_number',
        'checkin_status',
        'checkout_status',
        'checkin_datetime',
        'checkout_datetime',
        'checkin_weight',
        'checkin_weight_unit',
        'checkout_weight',
        'checkout_weight_unit',
        'net_weight',
        'net_weight_unit',
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
        'statuses',
        'settings',
        'contracts',
        'requests',
        'quotations',
        'currencies',
        'exchange_rates',
        'sale_order_requests',
        'rates',
        'currency',
        'contract',
        'request',
        'form_numbers',
        'pfi',
        'order',
        'status',
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
      final queryParams = <String, dynamic>{};
      if (creatorId != null) {
        queryParams['creatorId'] = creatorId;
      }
      final response = await client.get(
        '/product/getItem',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final list = _extractList(response.data);
      return list.map((m) => _normalizeProductJson(m)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> _getMetadataSimple(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'length': '10000',
        'limit': '10000',
        'per_page': '10000',
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
      final queryParams = <String, dynamic>{};
      if (creatorId != null) {
        queryParams['creatorId'] = creatorId;
      }
      final resp = await client.get(
        '/product/getProductUnit',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
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
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getWarehouses() async {
    return await _getMetadataSimple('/warehouse/getWarehouse');
  }

  Future<List<Map<String, dynamic>>> getQuotations() async {
    try {
      final resp = await client.get('/sales/getSaleOrderPFI');
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getContracts() async {
    try {
      final resp = await client.get('/contract/getSaleOrderContract');
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRequests() async {
    try {
      final resp = await client.get('/sales/getSaleOrderRequest');
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTaxes() async {
    try {
      final resp = await client.get('/sales/getTaxes');
      return _extractList(resp.data);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCurrencies() async {
    return await _getMetadataSimple('/logistic/getCurrency');
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
        if (decoded is Map && decoded.containsKey('rate')) {
          return double.tryParse(decoded['rate'].toString());
        }
      }
    } catch (_) {}
    return null;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    return await _getMetadataSimple('/user/getUsers');
  }

  Future<List<Map<String, dynamic>>> getJobCards() async {
    return await _getMetadataSimple('/jobcard/getJobCard');
  }

  Future<List<Map<String, dynamic>>> getSupportTickets() async {
    return await _getMetadataSimple('/support/getSupportTicket');
  }

  Future<List<Map<String, dynamic>>> getProjects() async {
    return await _getMetadataSimple('/get-projects');
  }

  Future<List<Map<String, dynamic>>> getTrips() async {
    return await _getMetadataSimple('/trip/getTrip/');
  }

  Future<List<Map<String, dynamic>>> getPaymentTerms() async {
    return await _getMetadataSimple('/logistic/getPaymentTerm');
  }

  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    return await _getMetadataSimple('/logistic/getPaymentMethod');
  }

  Future<List<Map<String, dynamic>>> getPriorities() async {
    return await _getMetadataSimple('/support/getSupportPriority');
  }

  Future<List<Map<String, dynamic>>> getCargoUnits() async {
    return await _getMetadataSimple('/logistic/getCargoUnit');
  }

  Future<List<Map<String, dynamic>>> getPaymentTypes() async {
    return await _getMetadataSimple('/logistic/getPaymentType');
  }

  Future<List<Map<String, dynamic>>> getDiscountTypes() async {
    return await _getMetadataSimple('/logistic/getDiscountType');
  }

  Future<List<Map<String, dynamic>>> getSubscriptionDurations() async {
    return await _getMetadataSimple('/logistic/getSubscriptionDuration');
  }

  Future<List<Map<String, dynamic>>> getDeliveryNotes() async {
    return await _getMetadataSimple('/delivery_note/getDeliveryNote');
  }

  Future<List<Map<String, dynamic>>> getSaleOrders() async {
    return await _getMetadataSimple('/order/getSaleOrder');
  }

  /// POST /order/saveOrder
  ///
  /// [payload] can be either a plain `Map<String, dynamic>` (sent as JSON) or
  /// a `FormData` instance (sent as multipart/form-data when file uploads are
  /// included such as priority_document, lpo_document, or proof_of_payment).
  Future<Map<String, dynamic>> saveOrder(dynamic payload) async {
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

  /// GET /generateUniqueNumber?table={table}&column={column}
  /// Returns a generated number as a string when available.
  Future<String?> generateUniqueNumber(String table, String column) async {
    try {
      final resp = await client.get(
        '/generateUniqueNumber',
        queryParameters: {'table': table, 'column': column},
        options: Options(extra: {'noAuth': true}),
      );
      return _tryParseNextNumber(resp.data);
    } catch (e) {
      // ignore: avoid_print
      print(
        '[SalesRemoteDataSource] generateUniqueNumber error for $table: $e',
      );
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
      if (raw['proposal_number'] != null)
        return raw['proposal_number'].toString();
      for (final v in raw.values) {
        if (v is String && v.isNotEmpty) return v;
      }
    }
    if (raw is num) return raw.toString();
    return null;
  }
}
