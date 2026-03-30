import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import 'package:workwise_erp/core/models/paginated_response.dart';

import '../models/jobcard_model.dart';
import '../models/jobcard_detail_model.dart';

class JobcardRemoteDataSource {
  final Dio client;
  JobcardRemoteDataSource(this.client);

  // helper to extract list payloads (handles envelope shapes and stringified JSON)
  List<Map<String, dynamic>> _extractList(dynamic raw) {
    if (raw is List) {
      return raw
          .map((e) {
            if (e is Map) return Map<String, dynamic>.from(e);
            return <String, dynamic>{};
          })
          .where((m) => m.isNotEmpty)
          .toList();
    }
    if (raw is Map) {
      // common envelope keys
      if (raw['data'] is List) {
        return (raw['data'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      if (raw['jobcards'] is List) {
        return (raw['jobcards'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      if (raw['items'] is List) {
        return (raw['items'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      if (raw['records'] is List) {
        return (raw['records'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      if (raw['payload'] is List) {
        return (raw['payload'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      // Settings-specific keys
      if (raw['settings'] is List) {
        return (raw['settings'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      if (raw['statuses'] is List) {
        return (raw['statuses'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      if (raw['jobcard_settings'] is List) {
        return (raw['jobcard_settings'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      if (raw['jobcard_statuses'] is List) {
        return (raw['jobcard_statuses'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      // nested data/payload -> list (handles Laravel paginator: {data: {data: [...], last_page: N}})
      final inner = (raw['data'] is Map
          ? raw['data'] as Map
          : (raw['payload'] is Map ? raw['payload'] as Map : null));
      if (inner != null) {
        if (inner['data'] is List) {
          return (inner['data'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
        if (inner['jobcards'] is List) {
          return (inner['jobcards'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
        if (inner['settings'] is List) {
          return (inner['settings'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
        if (inner['statuses'] is List) {
          return (inner['statuses'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
        if (inner['status'] is List) {
          return (inner['status'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
        if (inner['items'] is List) {
          return (inner['items'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
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
        return _extractList(decoded);
      } catch (_) {
        throw ServerException('Invalid JSON response from server');
      }
    }
    return <Map<String, dynamic>>[];
  }

  /// GET /jobcard/getJobCard — fetches a single page.
  Future<PaginatedResponse<JobcardModel>> getJobcards({
    int page = 1,
    int perPage = 100,
    String? status,
    bool force = false,
  }) async {
    try {
      final extra = force
          ? <String, dynamic>{'no_cache': true}
          : <String, dynamic>{};
      final resp = await client.get(
        '/jobcard/getJobCard',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'page_length': perPage,
          'limit_page_length': perPage,
          'limit_start': (page - 1) * perPage,
          'start': (page - 1) * perPage,
          'length': perPage,
          'limit': perPage,
          'offset': (page - 1) * perPage,
          if (status != null) 'status': status,
        },
        options: Options(extra: extra),
      );

      final raw = resp.data;

      // Extract items
      final items = _extractList(
        raw,
      ).map((e) => JobcardModel.fromJson(e)).toList();

      // Detect last_page, total, etc. from Laravel/Common paginator
      int total = items.length;
      int lastPage = 1;
      int currentPage = page;
      int actualPerPage = perPage;

      if (raw is Map) {
        final paginator = raw['data'] is Map
            ? raw['data'] as Map
            : (raw['payload'] is Map ? raw['payload'] as Map : raw);

        final lp =
            paginator['last_page'] ??
            paginator['lastPage'] ??
            paginator['total_pages'] ??
            paginator['totalPages'];
        if (lp is num && lp > 0) {
          lastPage = lp.toInt();
        } else if (lp is String) {
          lastPage = int.tryParse(lp) ?? 1;
        }

        final t =
            paginator['total'] ??
            paginator['records_total'] ??
            paginator['recordsTotal'];
        if (t is num) {
          total = t.toInt();
        } else if (t is String) {
          total = int.tryParse(t) ?? items.length;
        }

        final cp =
            paginator['current_page'] ?? paginator['currentPage'] ?? page;
        currentPage = cp is num
            ? cp.toInt()
            : (int.tryParse(cp?.toString() ?? '') ?? page);

        final pp =
            paginator['per_page'] ??
            paginator['per_page_length'] ??
            paginator['limit'] ??
            perPage;
        actualPerPage = pp is num
            ? pp.toInt()
            : (int.tryParse(pp?.toString() ?? '') ?? perPage);
        if (actualPerPage <= 0) actualPerPage = perPage;

        // Fallback: calculate lastPage from total + per_page
        if (lastPage <= 1 && total > actualPerPage) {
          lastPage = (total / actualPerPage).ceil();
        }
      }

      return PaginatedResponse<JobcardModel>(
        items: items,
        total: total,
        currentPage: currentPage,
        lastPage: lastPage,
        perPage: actualPerPage,
      );
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) {
          throw ServerException('Server returned HTML for /jobcard/getJobCard');
        }
      }
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /jobcard/getJobCardRow/{id}
  Future<JobcardDetailModel> getJobcardById(int id) async {
    try {
      final resp = await client.get('/jobcard/getJobCardRow/$id');
      final raw = resp.data;

      Map<String, dynamic>? map;
      if (raw is Map && raw['data'] is Map) {
        map = Map<String, dynamic>.from(raw['data'] as Map);
      } else if (raw is Map) {
        map = Map<String, dynamic>.from(raw);
      } else if (raw is String) {
        final s = raw.trim();
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /jobcard/getJobCardRow/$id',
          );
        }
        try {
          final decoded = json.decode(s);
          if (decoded is Map && decoded['data'] is Map) {
            map = Map<String, dynamic>.from(decoded['data'] as Map);
          }
        } catch (_) {
          throw ServerException('Invalid JSON response from server');
        }
      }

      if (map == null) {
        throw ServerException('Unexpected response format for jobcard/$id');
      }
      return JobcardDetailModel.fromJson(map);
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /jobcard/getJobCardRow/$id',
          );
        }
      }
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /jobcard/getJobCardSetting (and fallback to /jobcard/getJobCardSettings)
  Future<List<Map<String, dynamic>>> getJobcardSettings() async {
    // This endpoint varies across backends and may return:
    // - A raw list of statuses
    // - { data: [...], ... }
    // - { jobcard_settings: [...] }
    // When the response format changes, our tab list can end up empty.
    // We attempt multiple endpoints and scan the returned map for the first list.

    Future<List<Map<String, dynamic>>> tryFetch(String path) async {
      final resp = await client.get(path);
      final raw = resp.data;

      debugPrint('[JobcardSettings] GET $path -> ${raw.runtimeType}');
      if (raw is Map) {
        debugPrint('[JobcardSettings] keys: ${raw.keys.toList()}');
      }

      return _extractList(raw);
    }

    try {
      var list = await tryFetch('/jobcard/getJobCardSetting');
      if (list.isEmpty) {
        list = await tryFetch('/jobcard/getJobCardSettings');
      }
      return list;
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /jobcard/getJobCardSetting',
          );
        }
      }
      // If the error is 404, retry with the alternate endpoint before failing.
      if (e.response?.statusCode == 404) {
        try {
          return await tryFetch('/jobcard/getJobCardSettings');
        } catch (_) {
          // fall through to throw below
        }
      }
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /jobcard/getJobCardSetting  (also returns a single config object on some backends)
  Future<Map<String, dynamic>> getJobcardConfig() async {
    try {
      final resp = await client.get('/jobcard/getJobCardSetting');
      final raw = resp.data;

      Map<String, dynamic>? result;

      // If API returned { data: { ...settings... } }, return that map
      if (raw is Map) {
        if (raw['data'] is Map) {
          result = Map<String, dynamic>.from(raw['data'] as Map);
        } else if (raw.containsKey('jobcard_prefix') ||
            raw.containsKey('enable_reminder')) {
          // payload itself is a settings map
          result = Map<String, dynamic>.from(raw);
        }
      }

      if (result == null) {
        // If we reach here the response didn't contain a config map
        throw ServerException('Unexpected format for jobcard config');
      }

      // Debug: dump all keys so we can verify the actual field names
      debugPrint('[JobcardConfig] keys: ${result.keys.toList()}');
      debugPrint(
        '[JobcardConfig] after_reject_status=${result['after_reject_status']} '
        'next_status_after_approval=${result['next_status_after_approval']} '
        'next_status_after_jobcard_completion=${result['next_status_after_jobcard_completion']} '
        'remind_on_status=${result['remind_on_status']} '
        'notification_on_status=${result['notification_on_status']}',
      );

      return result;
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /jobcard/getJobCardSetting',
          );
        }
      }
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /jobcard/getJobCardDashboardData
  Future<List<Map<String, dynamic>>> getDashboardData() async {
    try {
      final resp = await client.get('/jobcard/getJobCardDashboardData');
      final raw = resp.data;
      // Response: { status, message, data: [ {id, name, color, total}, ... ] }
      if (raw is Map && raw['data'] is List) {
        return (raw['data'] as List)
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      return _extractList(raw);
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// DELETE /jobcard/deleteJobCard/{id}
  Future<void> deleteJobcard(int id) async {
    try {
      final resp = await client.delete('/jobcard/deleteJobCard/$id');
      final respData = resp.data;
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /jobcard/deleteJobCard/$id',
          );
        }
      }
      return;
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /jobcard/deleteJobCard/$id',
          );
        }
      }
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// POST /jobcard/changeJobCardStatus
  Future<void> changeJobcardStatus(int id, int status, {String? note}) async {
    try {
      final payload = <String, dynamic>{
        'id': id,
        'status': status,
        if (note != null && note.isNotEmpty) 'note': note,
      };
      final resp = await client.post(
        '/jobcard/changeJobCardStatus',
        data: payload,
      );
      final raw = resp.data;
      if (raw is String && raw.trim().startsWith('<')) {
        throw ServerException(
          'Server returned HTML for /jobcard/changeJobCardStatus',
        );
      }
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is String && respData.trim().startsWith('<')) {
        throw ServerException(
          'Server returned HTML for /jobcard/changeJobCardStatus',
        );
      }
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Approval / rejection
  // ──────────────────────────────────────────────────────────────────────────

  /// POST /jobcard/checkApprovalEligibility
  /// Returns the raw response map; caller inspects status/message.
  Future<Map<String, dynamic>> checkApprovalEligibility(int jobcardId) async {
    try {
      final resp = await client.post(
        '/jobcard/checkApprovalEligibility',
        data: {'jobcard_id': jobcardId},
      );
      final raw = resp.data;
      if (raw is Map) return Map<String, dynamic>.from(raw);
      if (raw is String && raw.trim().startsWith('<')) {
        throw ServerException(
          'Server returned HTML for checkApprovalEligibility',
        );
      }
      return <String, dynamic>{'status': 200};
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// POST /logistic/jobCardApproval
  ///
  /// Query params:
  /// - jobcard_id
  /// - role_user_id
  /// - approval_id
  /// - status (2 = reject, 3 = approve)
  /// - comment (optional)
  Future<void> submitJobcardApproval({
    required int jobcardId,
    required int status,
    required int approvalId,
    required int roleUserId,
    String? comment,
  }) async {
    try {
      final params = <String, dynamic>{
        'status': status,
        'jobcard_id': jobcardId,
        'approval_id': approvalId,
        'role_user_id': roleUserId,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      };
      print('[jobCardApproval] params: $params');
      final resp = await client.post(
        '/logistic/jobCardApproval',
        queryParameters: params,
      );

      final raw = resp.data;
      print('[jobCardApproval] status: ${resp.statusCode}');
      print('[jobCardApproval] response: $raw');
      if (raw is String && raw.trim().startsWith('<')) {
        throw ServerException(
          'Server returned HTML for /logistic/jobCardApproval',
        );
      }
    } on DioException catch (e) {
      final respData = e.response?.data;
      print('[jobCardApproval] DioException status: ${e.response?.statusCode}');
      print('[jobCardApproval] DioException response: $respData');
      print('[jobCardApproval] DioException message: ${e.message}');
      if (respData is String && respData.trim().startsWith('<')) {
        throw ServerException(
          'Server returned HTML for /logistic/jobCardApproval',
        );
      }
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      print('[jobCardApproval] unexpected error: $e');
      throw ServerException(e.toString());
    }
  }

  /// POST /jobcard/approveJobCard
  ///
  /// Some backends accept an optional `reason`/`comment` for auditing.
  Future<void> approveJobcard(int jobcardId, {String? comment}) async {
    try {
      final resp = await client.post(
        '/jobcard/approveJobCard',
        data: {
          'jobcard_id': jobcardId,
          if (comment != null && comment.isNotEmpty) 'reason': comment,
        },
      );
      final raw = resp.data;
      if (raw is String && raw.trim().startsWith('<')) {
        throw ServerException('Server returned HTML for approveJobCard');
      }
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// POST /jobcard/rejectJobCard
  Future<void> rejectJobcard(int jobcardId, {String? reason}) async {
    try {
      final resp = await client.post(
        '/jobcard/rejectJobCard',
        data: {
          'jobcard_id': jobcardId,
          if (reason != null && reason.isNotEmpty) 'reason': reason,
        },
      );
      final raw = resp.data;
      if (raw is String && raw.trim().startsWith('<')) {
        throw ServerException('Server returned HTML for rejectJobCard');
      }
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Form-data helpers (dropdown catalogs required when creating a jobcard)
  // ──────────────────────────────────────────────────────────────────────────

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
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /user/getUsers
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final resp = await client.get('/user/getUsers', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /product/getItem?creatorId={creatorId}
  Future<List<Map<String, dynamic>>> getProducts({int? creatorId}) async {
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
      return _extractList(resp.data);
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /product/getProductUnit?creatorId={creatorId}
  Future<List<Map<String, dynamic>>> getProductUnits({int? creatorId}) async {
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
      return _extractList(resp.data);
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /user/getUsers | /customer/getCustomers | /logistic/getReceiverNames/{type}
  /// Routes 'user' → /user/getUsers, 'customer' → /customer/getCustomers,
  /// everything else (vendor, employee, …) → /logistic/getReceiverNames/{type}.
  Future<List<Map<String, dynamic>>> getReceiversByType(String type) async {
    try {
      final String endpoint;
      switch (type.toLowerCase()) {
        case 'user':
        case 'employee':
          endpoint = '/user/getUsers';
          break;
        case 'customer':
          endpoint = '/customer/getCustomers';
          break;
        default:
          endpoint = '/logistic/getReceiverNames/$type';
      }
      final resp = await client.get(endpoint, queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /customer/getCustomers
  Future<List<Map<String, dynamic>>> getCustomers() async {
    try {
      final resp = await client.get('/customer/getCustomers', queryParameters: {
        'length': '1000',
        'limit': '1000',
        'per_page': '1000',
        'all': '1',
      });
      return _extractList(resp.data);
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /logistic/getReceiverDetails?receiver={id}&receiver_for={receiverFor}
  /// receiverFor is one of: Customer | User | Vehicle
  /// Returns the `data` object from the response.
  Future<Map<String, dynamic>> getReceiverDetails(
    int id,
    String receiverFor,
  ) async {
    try {
      final resp = await client.get(
        '/logistic/getReceiverDetails',
        queryParameters: {'receiver': id, 'receiver_for': receiverFor},
      );
      if (resp.data is Map) {
        final data = (resp.data as Map)['data'];
        if (data is Map) return Map<String, dynamic>.from(data);
      }
      return {};
    } on DioException catch (e) {
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// POST /jobcard/saveJobCard
  /// Supports multipart upload when `item_attachemt` or `service_attachemt` are provided as
  /// lists of local file paths inside `payload`.
  /// Returns the server response as a normalized Map (may contain created id).
  Future<Map<String, dynamic>> saveJobcard(Map<String, dynamic> payload) async {
    try {
      // detect file-path lists and build FormData when needed
      final hasItemFiles =
          payload['item_attachemt'] is List &&
          (payload['item_attachemt'] as List).isNotEmpty;
      final hasServiceFiles =
          payload['service_attachemt'] is List &&
          (payload['service_attachemt'] as List).isNotEmpty;

      Response resp;
      if (hasItemFiles || hasServiceFiles) {
        final mapForForm = <String, dynamic>{};
        payload.forEach((k, v) {
          if (k == 'item_attachemt' || k == 'service_attachemt') {
            return; // handled below
          }
          mapForForm[k] = v;
        });

        if (hasItemFiles) {
          final paths = (payload['item_attachemt'] as List)
              .whereType<String>()
              .toList();
          if (paths.isNotEmpty) {
            mapForForm['item_attachemt'] = paths
                .map(
                  (p) => MultipartFile.fromFileSync(
                    p,
                    filename: p.split('/').last,
                  ),
                )
                .toList();
          }
        }
        if (hasServiceFiles) {
          final paths = (payload['service_attachemt'] as List)
              .whereType<String>()
              .toList();
          if (paths.isNotEmpty) {
            mapForForm['service_attachemt'] = paths
                .map(
                  (p) => MultipartFile.fromFileSync(
                    p,
                    filename: p.split('/').last,
                  ),
                )
                .toList();
          }
        }

        final form = FormData.fromMap(mapForForm);
        resp = await client.post('/jobcard/saveJobCard', data: form);
      } else {
        resp = await client.post('/jobcard/saveJobCard', data: payload);
      }

      final raw = resp.data;

      if (raw is Map) return Map<String, dynamic>.from(raw);

      if (raw is String) {
        final s = raw.trim();
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /jobcard/saveJobCard',
          );
        }
        try {
          final decoded = json.decode(s);
          if (decoded is Map) return Map<String, dynamic>.from(decoded);
        } catch (_) {
          throw ServerException(
            'Invalid JSON response from server for /jobcard/saveJobCard',
          );
        }
      }

      throw ServerException(
        'Unexpected response format for /jobcard/saveJobCard',
      );
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /jobcard/saveJobCard',
          );
        }
      }
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /generateUniqueNumber?table=logistic_jobcard&column=jobcard_number
  /// Returns a generated jobcard number as a string when available.
  /// This endpoint does not require an auth token; request is sent without Authorization header.
  ///
  /// NOTE: some backends return the value for the endpoint without query params —
  /// try the query-parameter form first, then fall back to the legacy call if
  /// the response is empty/null. This keeps compatibility with varying backends.
  Future<String?> generateUniqueNumber() async {
    String? tryParse(dynamic raw) {
      if (raw == null) return null;

      if (raw is String) {
        final s = raw.trim();
        if (s.isEmpty) return null;
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /generateUniqueNumber',
          );
        }
        // try to decode JSON string — return primitive decoded values (string/number)
        try {
          final decoded = json.decode(s);
          if (decoded is String) return decoded;
          if (decoded is num) return decoded.toString();
          if (decoded is Map) {
            if (decoded['data'] is String) return decoded['data'] as String;
            if (decoded['jobcard_number'] != null) {
              return decoded['jobcard_number'].toString();
            }
            if (decoded['number'] != null) return decoded['number'].toString();
          }
          // decoded to an unsupported primitive — fall back to the raw string
          return s;
        } catch (_) {
          return s;
        }
      }

      if (raw is Map) {
        if (raw['data'] is String) return raw['data'] as String;
        if (raw['data'] is Map && raw['data']['jobcard_number'] != null) {
          return raw['data']['jobcard_number'].toString();
        }
        if (raw['jobcard_number'] != null) {
          return raw['jobcard_number'].toString();
        }
        if (raw['number'] != null) return raw['number'].toString();
        // fallback: pick first string value
        for (final v in raw.values) {
          if (v is String && v.isNotEmpty) return v;
        }
      }

      return null;
    }

    try {
      // single attempt only — call the endpoint with required query params.
      assert(() {
        // ignore: avoid_print
        print(
          '[JobcardRemoteDataSource] Getting jobcard number — calling /generateUniqueNumber?table=logistic_jobcard&column=jobcard_number',
        );
        return true;
      }());

      final resp = await client.get(
        '/generateUniqueNumber',
        queryParameters: {
          'table': 'logistic_jobcard',
          'column': 'jobcard_number',
        },
        options: Options(extra: {'noAuth': true}),
      );

      assert(() {
        // ignore: avoid_print
        print(
          '[JobcardRemoteDataSource] Getting jobcard number — response status=${resp.statusCode} data=${resp.data}',
        );
        return true;
      }());

      final parsed = tryParse(resp.data);
      if (parsed != null && parsed.isNotEmpty) {
        assert(() {
          // ignore: avoid_print
          print('[JobcardRemoteDataSource] Got jobcard number: $parsed');
          return true;
        }());
        return parsed;
      }

      // No fallback to legacy endpoint — return null when primary response is empty.
      assert(() {
        // ignore: avoid_print
        print(
          '[JobcardRemoteDataSource] generateUniqueNumber: primary returned empty — no fallback; returning null',
        );
        return true;
      }());

      return null;
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (respData is String) {
        final s = respData.trim();
        if (s.startsWith('<')) {
          throw ServerException(
            'Server returned HTML for /generateUniqueNumber',
          );
        }
      }
      throw ServerException(friendlyDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
