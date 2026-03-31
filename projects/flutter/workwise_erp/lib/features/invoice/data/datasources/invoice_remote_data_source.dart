import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../models/invoice_model.dart';

class InvoiceRemoteDataSource {
  final Dio client;
  InvoiceRemoteDataSource(this.client);

  List<Map<String, dynamic>> _extractList(dynamic raw, {List<String>? keys}) {
    keys ??= ['data', 'items', 'records', 'payload', 'invoices'];
    if (raw is List) {
      return raw
          .map(
            (e) => e is Map<String, dynamic>
                ? Map<String, dynamic>.from(e)
                : <String, dynamic>{},
          )
          .toList();
    }
    if (raw is Map) {
      for (final k in keys) {
        if (raw[k] is List) {
          return (raw[k] as List)
              .map(
                (e) => e is Map<String, dynamic>
                    ? Map<String, dynamic>.from(e)
                    : <String, dynamic>{},
              )
              .toList();
        }
      }
      if (raw['data'] is Map) {
        final inner = raw['data'] as Map;
        for (final k in keys) {
          if (inner[k] is List) {
            return (inner[k] as List)
                .map(
                  (e) => e is Map<String, dynamic>
                      ? Map<String, dynamic>.from(e)
                      : <String, dynamic>{},
                )
                .toList();
          }
        }
      }
    }
    if (raw is String) {
      final s = raw.trim();
      if (s.startsWith('<')) {
        throw ServerException('Server returned HTML (check backend)');
      }
      try {
        final decoded = json.decode(s);
        return _extractList(decoded, keys: keys);
      } catch (_) {
        throw ServerException('Invalid JSON response from server');
      }
    }
    return <Map<String, dynamic>>[];
  }

  Future<List<InvoiceModel>> getInvoices() async {
    try {
      final resp = await client.get('/invoice/get');
      final list = _extractList(resp.data);
      final models = <InvoiceModel>[];
      for (final raw in list) {
        try {
          final src = Map<String, dynamic>.from(raw);
          models.add(InvoiceModel.fromJson(src));
        } catch (err) {
          // ignore: avoid_print
          print('warning: failed to parse invoice item: $err');
        }
      }
      return models;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<InvoiceModel> getInvoiceById(String id) async {
    try {
      final resp = await client.get('/invoice/get/$id');
      final raw = resp.data;
      if (raw is Map && raw['data'] != null) {
        return InvoiceModel.fromJson(Map<String, dynamic>.from(raw['data']));
      } else if (raw is Map) {
        return InvoiceModel.fromJson(Map<String, dynamic>.from(raw));
      }
      throw ServerException('Invalid response format');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> saveInvoice(Map<String, dynamic> data) async {
    try {
      final resp = await client.post('/invoice/save', data: data);
      if (resp.statusCode != 200) {
        throw ServerException(resp.data['message'] ?? 'Failed to save invoice');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> updateInvoice(String id, Map<String, dynamic> data) async {
    try {
      final resp = await client.post('/invoice/update/$id', data: data);
      if (resp.statusCode != 200) {
        throw ServerException(
          resp.data['message'] ?? 'Failed to update invoice',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteInvoice(String id) async {
    try {
      final resp = await client.delete('/invoice/delete/$id');
      if (resp.statusCode != 200) {
        throw ServerException(
          resp.data['message'] ?? 'Failed to delete invoice',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
