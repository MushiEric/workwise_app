import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/failure.dart';

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
  Future<Either<Failure, List<domain.SupportTicket>>> getTickets() async {
    try {
      final now = DateTime.now();
      if (_cache != null && _lastFetch != null && now.difference(_lastFetch!) < _cacheTtl) {
        // return cached copy
        final list = _cache!.map((m) => m.toDomain()).toList();
        return Either.right(list);
      }

      final List<SupportTicketModel> models = await remote.getSupportTickets();
      // update cache
      _cache = models;
      _lastFetch = DateTime.now();

      final list = models.map((m) => m.toDomain()).toList();
      return Either.right(list);
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
          id: m['id'] is int ? m['id'] as int : (m['id'] is String ? int.tryParse(m['id']) : null),
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
          id: m['id'] is int ? m['id'] as int : (m['id'] is String ? int.tryParse(m['id']) : null),
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
          id: m['id'] is int ? m['id'] as int : (m['id'] is String ? int.tryParse(m['id']) : null),
          name: m['name']?.toString(),
          isDefault: m['is_default'] is int ? m['is_default'] as int : (m['is_default'] is String ? int.tryParse(m['is_default']) : null),
          createdBy: m['created_by'] is int ? m['created_by'] as int : (m['created_by'] is String ? int.tryParse(m['created_by']) : null),
          updatedBy: m['updated_by'] is int ? m['updated_by'] as int : (m['updated_by'] is String ? int.tryParse(m['updated_by']) : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int ? m['archive'] as int : (m['archive'] is String ? int.tryParse(m['archive']) : null),
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
          id: m['id'] is int ? m['id'] as int : (m['id'] is String ? int.tryParse(m['id']) : null),
          customerId: m['customer_id']?.toString(),
          clientId: m['client_id']?.toString(),
          name: m['name']?.toString(),
          updatedBy: m['updated_by'] is int ? m['updated_by'] as int : (m['updated_by'] is String ? int.tryParse(m['updated_by']) : null),
          createdBy: m['created_by'] is int ? m['created_by'] as int : (m['created_by'] is String ? int.tryParse(m['created_by']) : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int ? m['archive'] as int : (m['archive'] is String ? int.tryParse(m['archive']) : null),
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
          id: m['id'] is int ? m['id'] as int : (m['id'] is String ? int.tryParse(m['id']) : null),
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
          createdBy: m['created_by'] is int ? m['created_by'] as int : (m['created_by'] is String ? int.tryParse(m['created_by']) : null),
          updatedBy: m['updated_by'] is int ? m['updated_by'] as int : (m['updated_by'] is String ? int.tryParse(m['updated_by']) : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int ? m['archive'] as int : (m['archive'] is String ? int.tryParse(m['archive']) : null),
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
          id: m['id'] is int ? m['id'] as int : (m['id'] is String ? int.tryParse(m['id']) : null),
          name: m['name']?.toString(),
          createdBy: m['created_by'] is int ? m['created_by'] as int : (m['created_by'] is String ? int.tryParse(m['created_by']) : null),
          updatedBy: m['updated_by'] is int ? m['updated_by'] as int : (m['updated_by'] is String ? int.tryParse(m['updated_by']) : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int ? m['archive'] as int : (m['archive'] is String ? int.tryParse(m['archive']) : null),
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
            id: u['id'] is int ? u['id'] as int : (u['id'] is String ? int.tryParse(u['id']) : null),
            name: u['name']?.toString(),
            type: u['type']?.toString(),
          );
        }

        return SupportSupervisor(
          id: m['id'] is int ? m['id'] as int : (m['id'] is String ? int.tryParse(m['id']) : null),
          entryNumber: m['entry_number']?.toString(),
          userId: m['user_id'] is int ? m['user_id'] as int : (m['user_id'] is String ? int.tryParse(m['user_id']) : null),
          relatedTo: m['related_to']?.toString(),
          supervisorCustomer: m['supervisor_customer']?.toString(),
          customersAll: m['customers_all']?.toString(),
          locationAll: m['location_all']?.toString(),
          departmentAll: m['department_all']?.toString(),
          branchesAll: m['branches_all']?.toString(),
          servicesAll: m['services_all']?.toString(),
          createdBy: m['created_by'] is int ? m['created_by'] as int : (m['created_by'] is String ? int.tryParse(m['created_by']) : null),
          updatedBy: m['updated_by'] is int ? m['updated_by'] as int : (m['updated_by'] is String ? int.tryParse(m['updated_by']) : null),
          createdAt: m['created_at']?.toString(),
          updatedAt: m['updated_at']?.toString(),
          archive: m['archive'] is int ? m['archive'] as int : (m['archive'] is String ? int.tryParse(m['archive']) : null),
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
  Future<Either<Failure, void>> changeTicketStatus({required int ticketId, required int statusId}) async {
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
  Future<Either<Failure, void>> changeTicketPriority({required int ticketId, required int priorityId}) async {
    try {
      await remote.changeTicketPriority(ticketId: ticketId, priorityId: priorityId);
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
  Future<Either<Failure, void>> createTicket({required SupportCreateParams params}) async {
    try {
      final fields = <String, dynamic>{
        'subject': params.subject,
        if (params.priorityId != null) 'priority': params.priorityId,
        if (params.endDate != null) 'end_date': params.endDate,
        if (params.description != null) 'description': params.description,
        if (params.assignees != null && params.assignees!.isNotEmpty) 'assignees[]': params.assignees,
        if (params.serviceId != null) 'service_id': params.serviceId,
        if (params.categoryId != null) 'category_id': params.categoryId,
        if (params.locationId != null) 'location_id': params.locationId,
        if (params.supervisorId != null) 'supervisor': params.supervisorId,
      };

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

