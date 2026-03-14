import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/support_ticket.dart' as domain;
import '../../domain/entities/status.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/support_category.dart';
import '../../domain/entities/support_department.dart';
import '../../domain/entities/support_location.dart';
import '../../domain/entities/support_supervisor.dart';
import '../../domain/entities/support_service.dart';
import '../../domain/entities/assigned_user.dart';
import '../../domain/entities/support_create_params.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_data_source.dart';
import '../models/support_ticket_model.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remote;

  // Simple in-memory cache to avoid hitting the server on every page visit.
  // Cache is kept short because tickets are created frequently.
  List<SupportTicketModel>? _cache;
  DateTime? _lastFetch;
  static const Duration _cacheTtl = Duration(seconds: 20);

  SupportRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<domain.SupportTicket>>> getTickets({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final List<SupportTicketModel> models = await remote.getSupportTickets(
        page: page,
        limit: limit,
      );
      final list = models.map((m) => m.toDomain()).toList();
      return Either.right(list);
=======
      // Fetch tickets raw JSON and metadata in parallel so we can resolve IDs to names
      final results = await Future.wait([
        remote.getSupportTicketsRaw(page: page, limit: limit),
        remote.getSupportCategories().catchError((_) => <Map<String, dynamic>>[]),
        remote.getSupportDepartments().catchError((_) => <Map<String, dynamic>>[]),
        remote.getSupportSupervisors().catchError((_) => <Map<String, dynamic>>[]),
      ]);

      final rawTickets = results[0] as List<Map<String, dynamic>>;
      final categories = results[1] as List<Map<String, dynamic>>;
      final departments = results[2] as List<Map<String, dynamic>>;
      final supervisors = results[3] as List<Map<String, dynamic>>;

      // Build lookup maps: id -> name
      final catLookup = <int, String>{};
      for (final c in categories) {
        final id = c['id'] is int ? c['id'] as int : (c['id'] is String ? int.tryParse(c['id'] as String) : null);
        final name = c['name']?.toString();
        if (id != null && name != null) catLookup[id] = name;
      }

      final deptLookup = <int, String>{};
      for (final d in departments) {
        final id = d['id'] is int ? d['id'] as int : (d['id'] is String ? int.tryParse(d['id'] as String) : null);
        final name = d['name']?.toString();
        if (id != null && name != null) deptLookup[id] = name;
      }

      final supLookup = <int, String>{};
      for (final s in supervisors) {
        final id = s['id'] is int ? s['id'] as int : (s['id'] is String ? int.tryParse(s['id'] as String) : null);
        // Supervisor name may be in nested 'user' object or directly on the record
        String? name;
        if (s['user'] is Map) {
          name = (s['user'] as Map)['name']?.toString();
        }
        name ??= s['name']?.toString();
        if (id != null && name != null) supLookup[id] = name;
      }

      // Resolve IDs to names in each ticket JSON, then parse into models
      final List<domain.SupportTicket> tickets = [];
      for (final json in rawTickets) {
        try {
          // Resolve category
          if (json['category'] == null && json['_category_id'] is int) {
            final catName = catLookup[json['_category_id'] as int];
            if (catName != null) json['category'] = catName;
          }

          // Resolve department
          if (json['department'] == null && json['_department_id'] is int) {
            final deptName = deptLookup[json['_department_id'] as int];
            if (deptName != null) json['department'] = deptName;
          }

          // Resolve supervisor
          if (json['_supervisor_id'] is int) {
            final supName = supLookup[json['_supervisor_id'] as int];
            if (supName != null) {
              json['supervisors'] = <String>[supName];
            }
          }

          final model = SupportTicketModel.fromJson(json);
          tickets.add(model.toDomain());
        } catch (err) {
          // ignore: avoid_print
          print('Warning: failed to parse support ticket item: $err');
        }
      }

      return Either.right(tickets);
>>>>>>> f3f03e6 (changes made on support tickets)
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  /// Call this when tickets are changed (created/updated) to invalidate cache.
  void invalidateCache() {
    _cache = null;
    _lastFetch = null;
  }

  @override
  Future<Either<Failure, List<SupportStatus>>> getStatuses() async {
    try {
      final raw = await remote.getSupportStatuses();
      final list = raw.map((m) {
        return SupportStatus(
          id: m['id'] is int
              ? m['id'] as int
              : (m['id'] is String ? int.tryParse(m['id']) : null),
          status: m['status']?.toString(),
          color: m['color']?.toString(),
        );
      }).toList();
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Priority>>> getPriorities() async {
    try {
      final raw = await remote.getSupportPriorities();
      final list = raw.map((m) {
        return Priority(
          id: m['id'] is int
              ? m['id'] as int
              : (m['id'] is String ? int.tryParse(m['id']) : null),
          priority: m['priority']?.toString(),
          color: m['color']?.toString(),
        );
      }).toList();
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SupportCategory>>> getCategories() async {
    try {
      final raw = await remote.getSupportCategories();
      final list = raw.map((m) {
        return SupportCategory(
          id: m['id'] is int
              ? m['id'] as int
              : (m['id'] is String ? int.tryParse(m['id']) : null),
          name: m['name']?.toString(),
          isDefault: m['is_default'] is int
              ? m['is_default'] as int
              : (m['is_default'] is String
                    ? int.tryParse(m['is_default'])
                    : null),
          createdBy: m['created_by'] is int
              ? m['created_by'] as int
              : (m['created_by'] is String
                    ? int.tryParse(m['created_by'])
                    : null),
          updatedBy: m['updated_by'] is int
              ? m['updated_by'] as int
              : (m['updated_by'] is String
                    ? int.tryParse(m['updated_by'])
                    : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int
              ? m['archive'] as int
              : (m['archive'] is String ? int.tryParse(m['archive']) : null),
        );
      }).toList();
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SupportDepartment>>> getDepartments() async {
    try {
      final raw = await remote.getSupportDepartments();
      final list = raw.map((m) {
        return SupportDepartment(
          id: m['id'] is int
              ? m['id'] as int
              : (m['id'] is String ? int.tryParse(m['id']) : null),
          customerId: m['customer_id']?.toString(),
          clientId: m['client_id']?.toString(),
          name: m['name']?.toString(),
          updatedBy: m['updated_by'] is int
              ? m['updated_by'] as int
              : (m['updated_by'] is String
                    ? int.tryParse(m['updated_by'])
                    : null),
          createdBy: m['created_by'] is int
              ? m['created_by'] as int
              : (m['created_by'] is String
                    ? int.tryParse(m['created_by'])
                    : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int
              ? m['archive'] as int
              : (m['archive'] is String ? int.tryParse(m['archive']) : null),
        );
      }).toList();
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SupportLocation>>> getLocations() async {
    try {
      final raw = await remote.getSupportLocations();
      final list = raw.map((m) {
        return SupportLocation(
          id: m['id'] is int
              ? m['id'] as int
              : (m['id'] is String ? int.tryParse(m['id']) : null),
          name: m['name']?.toString(),
          number: m['number']?.toString(),
          latitude: m['latitude']?.toString(),
          longitude: (m['longtude'] ?? m['longitude'])?.toString(),
          countryId: m['country_id']?.toString(),
          regionId: m['region_id']?.toString(),
          districtId: m['district_id']?.toString(),
          customerId: m['customer_id']?.toString(),
          clientId: m['client_id']?.toString(),
          zone: m['zone']?.toString(),
          phone: m['phone']?.toString(),
          fax: m['fax']?.toString(),
          address: m['address']?.toString(),
          createdBy: m['created_by'] is int
              ? m['created_by'] as int
              : (m['created_by'] is String
                    ? int.tryParse(m['created_by'])
                    : null),
          updatedBy: m['updated_by'] is int
              ? m['updated_by'] as int
              : (m['updated_by'] is String
                    ? int.tryParse(m['updated_by'])
                    : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int
              ? m['archive'] as int
              : (m['archive'] is String ? int.tryParse(m['archive']) : null),
          locationNumber: m['location_number']?.toString(),
        );
      }).toList();
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SupportService>>> getServices() async {
    try {
      final raw = await remote.getSupportServices();
      final list = raw.map((m) {
        return SupportService(
          id: m['id'] is int
              ? m['id'] as int
              : (m['id'] is String ? int.tryParse(m['id']) : null),
          name: m['name']?.toString(),
          createdBy: m['created_by'] is int
              ? m['created_by'] as int
              : (m['created_by'] is String
                    ? int.tryParse(m['created_by'])
                    : null),
          updatedBy: m['updated_by'] is int
              ? m['updated_by'] as int
              : (m['updated_by'] is String
                    ? int.tryParse(m['updated_by'])
                    : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int
              ? m['archive'] as int
              : (m['archive'] is String ? int.tryParse(m['archive']) : null),
        );
      }).toList();
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SupportSupervisor>>> getSupervisors() async {
    try {
      final raw = await remote.getSupportSupervisors();
      final list = raw.map((m) {
        // user may be nested — map to AssignedUser (id/name/type) when available
        AssignedUser? user;
        if (m['user'] is Map<String, dynamic>) {
          final u = m['user'] as Map<String, dynamic>;
          user = AssignedUser(
            id: u['id'] is int
                ? u['id'] as int
                : (u['id'] is String ? int.tryParse(u['id']) : null),
            name: u['name']?.toString(),
            type: u['type']?.toString(),
          );
        }

        return SupportSupervisor(
          id: m['id'] is int
              ? m['id'] as int
              : (m['id'] is String ? int.tryParse(m['id']) : null),
          entryNumber: m['entry_number']?.toString(),
          userId: m['user_id'] is int
              ? m['user_id'] as int
              : (m['user_id'] is String ? int.tryParse(m['user_id']) : null),
          relatedTo: m['related_to']?.toString(),
          supervisorCustomer: m['supervisor_customer']?.toString(),
          customersAll: m['customers_all']?.toString(),
          locationAll: m['location_all']?.toString(),
          departmentAll: m['department_all']?.toString(),
          branchesAll: m['branches_all']?.toString(),
          servicesAll: m['services_all']?.toString(),
          createdBy: m['created_by'] is int
              ? m['created_by'] as int
              : (m['created_by'] is String
                    ? int.tryParse(m['created_by'])
                    : null),
          updatedBy: m['updated_by'] is int
              ? m['updated_by'] as int
              : (m['updated_by'] is String
                    ? int.tryParse(m['updated_by'])
                    : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int
              ? m['archive'] as int
              : (m['archive'] is String ? int.tryParse(m['archive']) : null),
          user: user,
        );
      }).toList();
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final raw = await remote.getUsers();
      final list = raw.map((m) => UserModel.fromJson(m).toDomain()).toList();
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changeTicketStatus({
    required int ticketId,
    required int statusId,
  }) async {
    try {
      await remote.changeTicketStatus(ticketId: ticketId, statusId: statusId);
      invalidateCache();
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changeTicketPriority({
    required int ticketId,
    required int priorityId,
  }) async {
    try {
      await remote.changeTicketPriority(
        ticketId: ticketId,
        priorityId: priorityId,
      );
      invalidateCache();
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTicket({required int ticketId}) async {
    try {
      await remote.deleteSupportTicket(ticketId: ticketId);
      invalidateCache();
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createTicket({
    required SupportCreateParams params,
  }) async {
    try {
      final fields = <String, dynamic>{
        if (params.id != null) 'id': params.id,
        'subject': params.subject,
        if (params.priorityId != null) ...{
          'priority': params.priorityId,
          'priority_id': params.priorityId,
        },
        if (params.endDate != null) 'end_date': params.endDate,
        if (params.description != null) 'description': params.description,
        if (params.serviceId != null) 'service_id': params.serviceId,
        if (params.categoryId != null) 'category_id': params.categoryId,
        if (params.locationId != null) 'location_id': params.locationId,
        if (params.supervisorId != null) ...{
          'supervisor': params.supervisorId,
          'supervisor_id': params.supervisorId,
        },
        if (params.departmentId != null) 'department_id': params.departmentId,
        if (params.statusId != null) ...{
          'status_id': params.statusId,
          'status': params.statusId,
        },

        // Use consistent names for customer
        if (params.customerId != null) ...{
          'customer_id': params.customerId,
          'customer': params.customerId,
          'client_id': params.customerId,
        },

        // Send customer name so the backend can store it
        if (params.customerName != null) ...{
          'customer_name': params.customerName,
          'name': params.customerName,
        },

        // Send assignees list
        if (params.assignees != null && params.assignees!.isNotEmpty)
          'assignees[]': params.assignees,

        // Logged-in user should be the creator
        if (params.userId != null) ...{
          'user_id': params.userId,
          'user': params.userId,
          'staff_id': params.userId,
          'ticket_created': params.userId,
          'author_id': params.userId,
          'author': params.userId,
          'created_by': params.userId,
        },

        // Contacts list
        if (params.contactIds != null && params.contactIds!.isNotEmpty)
          'contacts[]': params.contactIds,
      };

      // ignore: avoid_print
      print('--- [REPO] createTicket Fields ---');
      fields.forEach((k, v) => print('  $k: $v'));
      // ignore: avoid_print
      print('--- [REPO] End createTicket Fields ---');

      await remote.saveSupportTicket(
        fields: fields,
        attachmentPaths: params.attachmentPaths,
        filePaths: params.files,
      );

      invalidateCache();
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
