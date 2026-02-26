import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/support_ticket_model.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

class SupportRemoteDataSource {
  final Dio client;
  SupportRemoteDataSource(this.client);

  // helper: extract list from common envelope shapes and string payloads
  List<Map<String, dynamic>> _extractListFromRaw(dynamic raw, {List<String>? keys}) {
    keys ??= ['data', 'tickets', 'items', 'records', 'payload'];
    if (raw is List) return raw.map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList();
    if (raw is Map) {
      for (final k in keys) {
        if (raw[k] is List) return (raw[k] as List).map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList();
      }
      // nested data -> key
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

  /// GET /support/getSupportTicket
  Future<List<SupportTicketModel>> getSupportTickets() async {
    try {
      final resp = await client.get('/support/getSupportTicket');
      final list = _extractListFromRaw(resp.data);

      // Normalize each ticket JSON to be defensive against backend shape changes
      List<SupportTicketModel> models = [];
      for (final raw in list) {
        try {
          final Map<String, dynamic> src = Map<String, dynamic>.from(raw);
          final normalized = _normalizeTicketJson(src);
          models.add(SupportTicketModel.fromJson(normalized));
        } catch (err) {
          // if a single item fails parsing, skip it but continue processing others
          // keep the error light and continue — caller will get partial list
          // ignore: avoid_print
          print('Warning: failed to parse support ticket item: $err');
        }
      }

      return models;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /support/getSupportStatus
  Future<List<Map<String, dynamic>>> getSupportStatuses() async {
    try {
      final resp = await client.get('/support/getSupportStatus');
      final list = _extractListFromRaw(resp.data);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /support/getSupportPriority
  Future<List<Map<String, dynamic>>> getSupportPriorities() async {
    try {
      final resp = await client.get('/support/getSupportPriority');
      final list = _extractListFromRaw(resp.data);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /support/getSupportCategory
  Future<List<Map<String, dynamic>>> getSupportCategories() async {
    try {
      final resp = await client.get('/support/getSupportCategory');
      final list = _extractListFromRaw(resp.data);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /support/getSupportDepartment
  Future<List<Map<String, dynamic>>> getSupportDepartments() async {
    try {
      final resp = await client.get('/support/getSupportDepartment');
      final list = _extractListFromRaw(resp.data);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /support/getSupportLocation
  Future<List<Map<String, dynamic>>> getSupportLocations() async {
    try {
      final resp = await client.get('/support/getSupportLocation');
      final list = _extractListFromRaw(resp.data);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /support/getSupportSupervisor
  Future<List<Map<String, dynamic>>> getSupportSupervisors() async {
    try {
      final resp = await client.get('/support/getSupportSupervisor');
      final list = _extractListFromRaw(resp.data);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /support/getSupport/Service
  Future<List<Map<String, dynamic>>> getSupportServices() async {
    try {
      final resp = await client.get('/support/getSupport/Service');
      final list = _extractListFromRaw(resp.data);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// POST /support/changeTicketStatus
  Future<void> changeTicketStatus({required int ticketId, required int statusId}) async {
    try {
      // Send multiple possible param names (server may expect different keys).
      final payload = {
        'ticket_id': ticketId,
        'id': ticketId,
        'status': statusId,
        'status_id': statusId,
      };

      final resp = await client.post('/support/changeTicketStatus', data: payload);

      final code = resp.statusCode ?? 500;
      if (code < 200 || code >= 300) {
        final msg = resp.data is Map<String, dynamic> && resp.data['message'] != null ? resp.data['message'].toString() : 'Failed to change ticket status';
        throw ServerException(msg);
      }
    } on DioException catch (e) {
      // If server returned a response with details, include it
      final respData = e.response?.data;
      if (respData is Map && respData['message'] != null) {
        throw ServerException(respData['message'].toString());
      }
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) throw ServerException('Server returned HTML (check backend)');
        try {
          final decoded = json.decode(s);
          if (decoded is Map && decoded['message'] != null) throw ServerException(decoded['message'].toString());
        } catch (_) {}
      }
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// POST /support/changeTicketPriority
  Future<void> changeTicketPriority({required int ticketId, required int priorityId}) async {
    try {
      final payload = {
        'ticket_id': ticketId,
        'id': ticketId,
        'priority': priorityId,
        'priority_id': priorityId,
      };

      final resp = await client.post('/support/changeTicketPriority', data: payload);

      final code = resp.statusCode ?? 500;
      if (code < 200 || code >= 300) {
        final msg = resp.data is Map<String, dynamic> && resp.data['message'] != null ? resp.data['message'].toString() : 'Failed to change ticket priority';
        throw ServerException(msg);
      }
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is Map && respData['message'] != null) {
        throw ServerException(respData['message'].toString());
      }
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) throw ServerException('Server returned HTML (check backend)');
        try {
          final decoded = json.decode(s);
          if (decoded is Map && decoded['message'] != null) throw ServerException(decoded['message'].toString());
        } catch (_) {}
      }
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// POST /support/deleteSupportTicket
  Future<void> deleteSupportTicket({required int ticketId}) async {
    try {
      final payload = {
        'ticket_id': ticketId,
        'id': ticketId,
      };

      final resp = await client.post('/support/deleteSupportTicket', data: payload);

      final code = resp.statusCode ?? 500;
      if (code < 200 || code >= 300) {
        final msg = resp.data is Map<String, dynamic> && resp.data['message'] != null ? resp.data['message'].toString() : 'Failed to delete ticket';
        throw ServerException(msg);
      }
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is Map && respData['message'] != null) {
        throw ServerException(respData['message'].toString());
      }
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) throw ServerException('Server returned HTML (check backend)');
        try {
          final decoded = json.decode(s);
          if (decoded is Map && decoded['message'] != null) throw ServerException(decoded['message'].toString());
        } catch (_) {}
      }
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// POST /support/saveSupportTicket (multipart/form-data)
  Future<void> saveSupportTicket({
    required Map<String, dynamic> fields,
    List<String>? attachmentPaths,
    List<String>? filePaths,
  }) async {
    try {
      final form = FormData();

      // simple fields and lists (e.g. assignees[])
      fields.forEach((k, v) {
        if (v == null) return;
        if (v is List) {
          for (final item in v) {
            form.fields.add(MapEntry(k, item.toString()));
          }
        } else {
          form.fields.add(MapEntry(k, v.toString()));
        }
      });

      // single attachment (API accepts 'attachment')
      if (attachmentPaths != null && attachmentPaths.isNotEmpty) {
        final path = attachmentPaths.first;
        try {
          form.files.add(MapEntry('attachment', MultipartFile.fromFileSync(path, filename: path.split('/').last)));
        } catch (_) {}
      }

      // multiple files[]
      if (filePaths != null && filePaths.isNotEmpty) {
        for (final p in filePaths) {
          try {
            form.files.add(MapEntry('files[]', MultipartFile.fromFileSync(p, filename: p.split('/').last)));
          } catch (_) {}
        }
      }

      final resp = await client.post('/support/saveSupportTicket', data: form);
      final code = resp.statusCode ?? 500;
      if (code < 200 || code >= 300) {
        final msg = resp.data is Map<String, dynamic> && resp.data['message'] != null ? resp.data['message'].toString() : 'Failed to create ticket';
        throw ServerException(msg);
      }
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is Map && respData['message'] != null) {
        throw ServerException(respData['message'].toString());
      }
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) throw ServerException('Server returned HTML (check backend)');
        try {
          final decoded = json.decode(s);
          if (decoded is Map && decoded['message'] != null) throw ServerException(decoded['message'].toString());
        } catch (_) {}
      }
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Attempt to coerce/normalize fields that may arrive as Map or nested structures
  Map<String, dynamic> _normalizeTicketJson(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);

    // Helper: ensure a field is String (or null)
    String? asString(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;
      if (v is num || v is bool) return v.toString();
      if (v is Map) {
        // common patterns: {"name": "..."} or {"title": "..."}
        if (v.containsKey('name') && v['name'] is String) return v['name'] as String;
        if (v.containsKey('title') && v['title'] is String) return v['title'] as String;
        if (v.containsKey('text') && v['text'] is String) return v['text'] as String;
        return v.toString();
      }
      return v.toString();
    }

    // Helper: ensure an integer id field
    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      if (v is Map && v.containsKey('id')) return asInt(v['id']);
      return null;
    }

    // Normalize simple string fields that sometimes come back as objects
    final stringFields = ['subject', 'ticket_code', 'end_date', 'description', 'category', 'location', 'department', 'created_at'];
    for (final f in stringFields) {
      if (out.containsKey(f)) out[f] = asString(out[f]);
    }

    // created_by may sometimes be an object instead of int
    if (out.containsKey('created_by')) out['created_by'] = asInt(out['created_by']);

    // Normalize attachments: ensure list of maps
    if (out.containsKey('attachments')) {
      final a = out['attachments'];
      if (a is String) {
        // sometimes backend returns JSON string — try to parse
        try {
          // ignore: avoid_dynamic_calls
          final parsed = a.isNotEmpty ? List<Map<String, dynamic>>.from([]) : <Map<String, dynamic>>[];
          out['attachments'] = parsed;
        } catch (_) {
          out['attachments'] = <Map<String, dynamic>>[];
        }
      } else if (a is List) {
        out['attachments'] = a.map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList();
      } else {
        out['attachments'] = <Map<String, dynamic>>[];
      }
    }

    // Replies: if not a list, coerce to empty list
    if (out.containsKey('replies')) {
      final r = out['replies'];
      if (r is List) {
        out['replies'] = r.map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList();
      } else {
        out['replies'] = <Map<String, dynamic>>[];
      }
    }

    // Support API sometimes provides `service` (single object) instead of `services` (list).
    // Normalize so downstream models always receive `services` as List<String>.
    if (out.containsKey('service') && out['service'] is Map) {
      final svc = out['service'] as Map<String, dynamic>;
      final svcName = asString(svc['name']);
      out['services'] = svcName != null ? <String>[svcName] : <String>[];
    }

    // Priority/status may sometimes be sent as string — if so, wrap into a minimal object
    if (out.containsKey('priority') && out['priority'] is String) {
      out['priority'] = {'priority': out['priority']};
    }
    if (out.containsKey('statuses') && out['statuses'] is String) {
      out['statuses'] = {'status': out['statuses']};
    }

    return out;
  }
}
