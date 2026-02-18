import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../entities/support_ticket.dart';
import '../entities/status.dart';
import '../entities/priority.dart';
import '../entities/support_category.dart';
import '../entities/support_department.dart';
import '../entities/support_location.dart';
import '../entities/support_supervisor.dart';
import '../entities/support_service.dart';
import '../entities/support_create_params.dart';

abstract class SupportRepository {
  Future<Either<Failure, List<SupportTicket>>> getTickets();

  Future<Either<Failure, List<SupportStatus>>> getStatuses();
  Future<Either<Failure, List<Priority>>> getPriorities();

  // New: support metadata used for ticket creation
  Future<Either<Failure, List<SupportCategory>>> getCategories();
  Future<Either<Failure, List<SupportDepartment>>> getDepartments();

  // Locations and supervisors for ticket creation
  Future<Either<Failure, List<SupportLocation>>> getLocations();
  Future<Either<Failure, List<SupportSupervisor>>> getSupervisors();

  // Services available for support tickets (GET /support/getSupport/Service)
  Future<Either<Failure, List<SupportService>>> getServices();

  Future<Either<Failure, void>> changeTicketStatus({required int ticketId, required int statusId});
  Future<Either<Failure, void>> changeTicketPriority({required int ticketId, required int priorityId});

  // Delete a support ticket by id
  Future<Either<Failure, void>> deleteTicket({required int ticketId});

  // Create a new support ticket (multipart/form-data for attachments/files)
  Future<Either<Failure, void>> createTicket({required SupportCreateParams params});
}
