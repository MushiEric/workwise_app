import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:workwise_erp/core/errors/exceptions.dart';
import '../models/customer_model.dart';
import '../models/customer_contact_model.dart';

class CustomerRemoteDataSource {
  final Dio client;
  CustomerRemoteDataSource(this.client);

  List<Map<String, dynamic>> _extractList(dynamic raw, {List<String>? keys}) {
    keys ??= ['data', 'customers', 'records'];
    if (raw is List) {
      return raw
          .map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{})
          .toList();
    }
    if (raw is Map) {
      for (final k in keys) {
        if (raw[k] is List) {
          return (raw[k] as List)
              .map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{})
              .toList();
        }
      }
    }
    if (raw is String) {
      final s = raw.trim();
      if (s.startsWith('<')) throw ServerException('Server returned HTML');
      try {
        return _extractList(json.decode(s), keys: keys);
      } catch (_) {
        throw ServerException('Invalid JSON response');
      }
    }
    return [];
  }

  /// GET /customer/getCustomers
  Future<List<CustomerModel>> getCustomers() async {
    try {
      final resp = await client.get('/customer/getCustomers', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      final list = _extractList(resp.data);
      final models = <CustomerModel>[];
      for (final raw in list) {
        try {
          models.add(CustomerModel.fromJson(raw));
        } catch (e) {
          // ignore malformed items
        }
      }
      return models;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /customer/getCustomerContact/{id}
  Future<List<CustomerContactModel>> getCustomerContacts(int customerId) async {
    try {
      final resp = await client.get('/customer/getCustomerContact/$customerId', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      final list = _extractList(resp.data);
      final models = <CustomerContactModel>[];
      for (final raw in list) {
        try {
          models.add(CustomerContactModel.fromJson(raw));
        } catch (e) {
          // ignore malformed items
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
