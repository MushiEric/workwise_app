import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/models/paginated_response.dart';

import '../../domain/entities/jobcard.dart' as domain;
import '../../domain/entities/jobcard_create_response.dart';
import '../../domain/entities/jobcard_form_data.dart';
import '../../domain/repositories/jobcard_repository.dart';
import '../datasources/jobcard_remote_data_source.dart';
import '../../domain/entities/jobcard_detail.dart';
import '../../domain/entities/jobcard_status.dart';

class JobcardRepositoryImpl implements JobcardRepository {
  final JobcardRemoteDataSource remote;
  JobcardRepositoryImpl(this.remote);

  @override
  Future<Either<dynamic, PaginatedResponse<domain.Jobcard>>> getJobcards({
    int page = 1,
    int perPage = 100,
    String? status,
    bool force = false,
  }) async {
    try {
      final paginatedModels = await remote.getJobcards(
        page: page,
        perPage: perPage,
        status: status,
        force: force,
      );

      final domainItems = paginatedModels.items
          .map((m) => m as domain.Jobcard)
          .toList();

      final paginatedDomain = PaginatedResponse<domain.Jobcard>(
        items: domainItems,
        total: paginatedModels.total,
        currentPage: paginatedModels.currentPage,
        lastPage: paginatedModels.lastPage,
        perPage: paginatedModels.perPage,
      );

      return Either.right(paginatedDomain);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, JobcardDetail>> getJobcardById(int id) async {
    try {
      final model = await remote.getJobcardById(id);
      return Either.right(model);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, List<Map<String, dynamic>>>> getDashboardData() async {
    try {
      final raw = await remote.getDashboardData();
      return Either.right(raw);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, List<JobcardStatus>>> getSettings() async {
    try {
      final raw = await remote.getJobcardSettings();

      // If raw is empty, return empty list instead of error
      if (raw.isEmpty) {
        return Either.right(<JobcardStatus>[]);
      }

      final list = raw
          .map((m) {
            // Try multiple field name variations
            int? id;
            if (m['id'] != null) {
              if (m['id'] is int) {
                id = m['id'] as int;
              } else if (m['id'] is String) {
                id = int.tryParse(m['id']);
              } else if (m['id'] is num) {
                id = (m['id'] as num).toInt();
              }
            }

            // Try multiple name field variations
            String? name =
                m['name']?.toString() ??
                m['status']?.toString() ??
                m['status_name']?.toString() ??
                m['label']?.toString() ??
                m['title']?.toString();

            // Try multiple color field variations
            String? color =
                m['color']?.toString() ??
                m['status_color']?.toString() ??
                m['colour']?.toString();

            return JobcardStatus(id: id, name: name, color: color);
          })
          .where((s) => s.name != null && s.name!.isNotEmpty)
          .toList();

      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, Map<String, dynamic>>> getConfig() async {
    try {
      final map = await remote.getJobcardConfig();
      return Either.right(map);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, void>> deleteJobcard({required int id}) async {
    try {
      await remote.deleteJobcard(id);
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, void>> changeJobcardStatus({
    required int id,
    required int status,
    String? note,
  }) async {
    try {
      await remote.changeJobcardStatus(id, status, note: note);
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, JobcardCreateResponse>> createJobcard({
    required params,
  }) async {
    try {
      // params expected to be a Map or an object with toJson/toMap
      Map<String, dynamic> payload;
      if (params is Map<String, dynamic>) {
        payload = params;
      } else if (params != null && params.toJson is Function) {
        payload = Map<String, dynamic>.from(params.toJson());
      } else if (params != null && params.toMap is Function) {
        payload = Map<String, dynamic>.from(params.toMap());
      } else {
        throw Exception('Invalid params for createJobcard');
      }

      // If attachments were provided as file paths, ensure the remote datasource will treat them as files
      // (we expect keys 'item_attachemt' and 'service_attachemt' to be lists of file paths)
      if (payload['item_attachemt'] is List<String> &&
          (payload['item_attachemt'] as List).isNotEmpty) {
        // leave as-is; remote will detect and convert to MultipartFile
      }
      if (payload['service_attachemt'] is List<String> &&
          (payload['service_attachemt'] as List).isNotEmpty) {
        // leave as-is
      }

      final resp = await remote.saveJobcard(payload);

      // Special-case: some backends return only {status: 200, message: '...'}
      // without providing an ID. Treat that as success and use the message.
      final statusValue = resp['status'];
      final messageValue = resp['message']?.toString();
      if ((statusValue == 200 || statusValue == '200') &&
          messageValue != null &&
          messageValue.isNotEmpty) {
        return Either.right(
          JobcardCreateResponse(id: null, message: messageValue, success: true),
        );
      }

      // try to extract id in common shapes
      // 1. data: { id: ... } or data: '123' or data: 123
      if (resp.containsKey('data')) {
        final d = resp['data'];
        // Try to extract an ID if present.
        if (d is Map && d['id'] != null)
          return Either.right(
            JobcardCreateResponse(
              id: int.tryParse(d['id'].toString()),
              message: resp['message']?.toString(),
              success: (resp['status']?.toString() ?? '').contains('200'),
            ),
          );
        if (d is Map && d['jobcard_id'] != null)
          return Either.right(
            JobcardCreateResponse(
              id: int.tryParse(d['jobcard_id'].toString()),
              message: resp['message']?.toString(),
              success: (resp['status']?.toString() ?? '').contains('200'),
            ),
          );
        if (d is num)
          return Either.right(
            JobcardCreateResponse(
              id: d.toInt(),
              message: resp['message']?.toString(),
              success: (resp['status']?.toString() ?? '').contains('200'),
            ),
          );
        if (d is String && int.tryParse(d) != null)
          return Either.right(
            JobcardCreateResponse(
              id: int.parse(d),
              message: resp['message']?.toString(),
              success: (resp['status']?.toString() ?? '').contains('200'),
            ),
          );
        if (d is List && d.isNotEmpty && d.first is Map) {
          final first = d.first as Map;
          if (first['id'] != null)
            return Either.right(
              JobcardCreateResponse(
                id: int.tryParse(first['id'].toString()),
                message: resp['message']?.toString(),
                success: (resp['status']?.toString() ?? '').contains('200'),
              ),
            );
          if (first['jobcard_id'] != null)
            return Either.right(
              JobcardCreateResponse(
                id: int.tryParse(first['jobcard_id'].toString()),
                message: resp['message']?.toString(),
                success: (resp['status']?.toString() ?? '').contains('200'),
              ),
            );
        }
      }

      // 2. top-level id variants
      final msg = resp['message']?.toString();
      final success = (resp['status']?.toString() ?? '').contains('200');

      if (resp['id'] != null) {
        final v = resp['id'];
        if (v is num)
          return Either.right(
            JobcardCreateResponse(
              id: v.toInt(),
              message: msg,
              success: success,
            ),
          );
        if (v is String && int.tryParse(v) != null)
          return Either.right(
            JobcardCreateResponse(
              id: int.parse(v),
              message: msg,
              success: success,
            ),
          );
      }
      if (resp['jobcard_id'] != null) {
        final v = resp['jobcard_id'];
        if (v is num)
          return Either.right(
            JobcardCreateResponse(
              id: v.toInt(),
              message: msg,
              success: success,
            ),
          );
        if (v is String && int.tryParse(v) != null)
          return Either.right(
            JobcardCreateResponse(
              id: int.parse(v),
              message: msg,
              success: success,
            ),
          );
      }
      if (resp['jobcardid'] != null) {
        final v = resp['jobcardid'];
        if (v is num)
          return Either.right(
            JobcardCreateResponse(
              id: v.toInt(),
              message: msg,
              success: success,
            ),
          );
        if (v is String && int.tryParse(v) != null)
          return Either.right(
            JobcardCreateResponse(
              id: int.parse(v),
              message: msg,
              success: success,
            ),
          );
      }

      // 3. jobcard: { id: ... }
      if (resp.containsKey('jobcard') &&
          resp['jobcard'] is Map &&
          resp['jobcard']['id'] != null) {
        return Either.right(
          JobcardCreateResponse(
            id: int.tryParse(resp['jobcard']['id'].toString()),
            message: resp['message']?.toString(),
            success: (resp['status']?.toString() ?? '').contains('200'),
          ),
        );
      }

      // 4. payload or nested shapes
      if (resp.containsKey('payload') && resp['payload'] is Map) {
        final p = resp['payload'] as Map;
        if (p['id'] != null)
          return Either.right(
            JobcardCreateResponse(
              id: int.tryParse(p['id'].toString()),
              message: resp['message']?.toString(),
              success: (resp['status']?.toString() ?? '').contains('200'),
            ),
          );
        if (p['jobcard_id'] != null)
          return Either.right(
            JobcardCreateResponse(
              id: int.tryParse(p['jobcard_id'].toString()),
              message: resp['message']?.toString(),
              success: (resp['status']?.toString() ?? '').contains('200'),
            ),
          );
      }

      // 5. fallback: try to find the first numeric-like value in the response
      // but ignore common HTTP response fields (status/code/message)
      for (final entry in resp.entries) {
        final key = entry.key.toString().toLowerCase();
        if (key == 'status' ||
            key == 'code' ||
            key == 'message' ||
            key == 'success')
          continue;
        final v = entry.value;
        if (v is num) {
          return Either.right(
            JobcardCreateResponse(
              id: v.toInt(),
              message: resp['message']?.toString(),
              success: (resp['status']?.toString() ?? '').contains('200'),
            ),
          );
        }
        if (v is String && int.tryParse(v) != null)
          return Either.right(
            JobcardCreateResponse(
              id: int.parse(v),
              message: resp['message']?.toString(),
              success: (resp['status']?.toString() ?? '').contains('200'),
            ),
          );
      }

      // Debug: include the raw response in logs (only in debug/assert builds)
      assert(() {
        // ignore: avoid_print
        print(
          '[JobcardRepositoryImpl] createJobcard: could not parse response for payload; raw response: $resp',
        );
        return true;
      }());

      // Try a deep search for an ID inside the response to avoid failures when
      // the server returns an unusual structure.
      int? deepId;
      int? findId(dynamic node) {
        if (node is Map) {
          for (final entry in node.entries) {
            final key = entry.key.toString().toLowerCase();
            if (key == 'id' || key == 'jobcard_id' || key == 'jobcardid') {
              final v = entry.value;
              if (v is num) return v.toInt();
              if (v is String && int.tryParse(v) != null) return int.parse(v);
            }
            final found = findId(entry.value);
            if (found != null) return found;
          }
        } else if (node is List) {
          for (final e in node) {
            final found = findId(e);
            if (found != null) return found;
          }
        }
        return null;
      }

      deepId = findId(resp);
      if (deepId != null)
        return Either.right(
          JobcardCreateResponse(
            id: deepId,
            message: resp['message']?.toString(),
            success: (resp['status']?.toString() ?? '').contains('200'),
          ),
        );

      return Either.left(ServerFailure('Failed to parse create response'));
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, String>> generateUniqueNumber() async {
    try {
      final s = await remote.generateUniqueNumber();
      if (s == null || s.isEmpty)
        return Either.left(ServerFailure('Failed to generate jobcard number'));
      return Either.right(s);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, JobcardFormData>> getFormData({int? creatorId}) async {
    try {
      final results = await Future.wait([
        remote.getVehicles(),
        remote.getUsers(),
        remote.getProducts(creatorId: creatorId),
        remote.getProductUnits(creatorId: creatorId),
      ]);
      return Either.right(
        JobcardFormData(
          vehicles: results[0],
          users: results[1],
          products: results[2],
          productUnits: results[3],
        ),
      );
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, List<Map<String, dynamic>>>> getReceiversByType(
    String type,
  ) async {
    try {
      final list = await remote.getReceiversByType(type);
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, Map<String, dynamic>>> checkApprovalEligibility(
    int jobcardId,
  ) async {
    try {
      final result = await remote.checkApprovalEligibility(jobcardId);
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, void>> approveJobcard(
    int jobcardId, {
    required int status,
    required int approvalId,
    required int roleUserId,
    String? comment,
  }) async {
    try {
      await remote.submitJobcardApproval(
        jobcardId: jobcardId,
        status: status,
        approvalId: approvalId,
        roleUserId: roleUserId,
        comment: comment,
      );
      return Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<dynamic, void>> rejectJobcard(
    int jobcardId, {
    required int status,
    required int approvalId,
    required int roleUserId,
    String? comment,
  }) async {
    try {
      await remote.submitJobcardApproval(
        jobcardId: jobcardId,
        status: status,
        approvalId: approvalId,
        roleUserId: roleUserId,
        comment: comment,
      );
      return Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
