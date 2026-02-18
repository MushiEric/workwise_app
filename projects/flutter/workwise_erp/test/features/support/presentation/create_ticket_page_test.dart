import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/support/domain/entities/support_service.dart';
import 'package:workwise_erp/features/support/domain/repositories/support_repository.dart';
import 'package:workwise_erp/features/support/domain/entities/priority.dart';
import 'package:workwise_erp/features/support/domain/entities/support_category.dart';
import 'package:workwise_erp/features/support/domain/entities/support_location.dart';
import 'package:workwise_erp/features/support/domain/entities/support_supervisor.dart';
import 'package:workwise_erp/features/support/domain/entities/support_ticket.dart';
import 'package:workwise_erp/features/support/domain/entities/status.dart';
import 'package:workwise_erp/features/support/domain/entities/support_department.dart';
import 'package:workwise_erp/features/support/domain/entities/support_create_params.dart';
import 'package:workwise_erp/features/support/domain/usecases/get_support_services.dart';
import 'package:workwise_erp/features/support/domain/usecases/get_support_priorities.dart';
import 'package:workwise_erp/features/support/domain/usecases/get_support_categories.dart';
import 'package:workwise_erp/features/support/domain/usecases/get_support_locations.dart';
import 'package:workwise_erp/features/support/domain/usecases/get_support_supervisors.dart';
import 'package:workwise_erp/features/support/presentation/pages/create_ticket_page.dart';
import 'package:workwise_erp/features/support/presentation/providers/support_providers.dart';

class _FakeRepoForCreate implements SupportRepository {
  @override
  Future<Either<Failure, List<Priority>>> getPriorities() async => Either.right(<Priority>[]);

  @override
  Future<Either<Failure, List<SupportCategory>>> getCategories() async => Either.right(<SupportCategory>[]);

  @override
  Future<Either<Failure, List<SupportLocation>>> getLocations() async => Either.right(<SupportLocation>[]);

  @override
  Future<Either<Failure, List<SupportSupervisor>>> getSupervisors() async => Either.right(<SupportSupervisor>[]);

  @override
  Future<Either<Failure, List<SupportService>>> getServices() async => Either.right([
        const SupportService(id: 1, name: 'HOSTING', createdBy: 3, updatedBy: 3, createdAt: '2026-01-07T11:57:15.000000Z')
      ]);

  // unused by this test (return correctly typed empty values)
  @override
  Future<Either<Failure, List<SupportTicket>>> getTickets() async => Either.right(<SupportTicket>[]);

  @override
  Future<Either<Failure, List<SupportStatus>>> getStatuses() async => Either.right(<SupportStatus>[]);

  @override
  Future<Either<Failure, void>> changeTicketStatus({required int ticketId, required int statusId}) async => Either.right(null);

  @override
  Future<Either<Failure, void>> changeTicketPriority({required int ticketId, required int priorityId}) async => Either.right(null);

  @override
  Future<Either<Failure, void>> deleteTicket({required int ticketId}) async => Either.right(null);

  @override
  Future<Either<Failure, void>> createTicket({required SupportCreateParams params}) async => Either.right(null);

  @override
  Future<Either<Failure, List<SupportDepartment>>> getDepartments() async => Either.right(<SupportDepartment>[]);
}

void main() {
  testWidgets('CreateTicketPage shows server-driven Services dropdown (HOSTING)', (tester) async {
    final repo = _FakeRepoForCreate();
    final getServices = GetSupportServices(repo);
    final getPriorities = GetSupportPriorities(repo);
    final getCategories = GetSupportCategories(repo);
    final getLocations = GetSupportLocations(repo);
    final getSupervisors = GetSupportSupervisors(repo);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        getSupportServicesUseCaseProvider.overrideWithValue(getServices),
        getSupportPrioritiesUseCaseProvider.overrideWithValue(getPriorities),
        getSupportCategoriesUseCaseProvider.overrideWithValue(getCategories),
        getSupportLocationsUseCaseProvider.overrideWithValue(getLocations),
        getSupportSupervisorsUseCaseProvider.overrideWithValue(getSupervisors),
      ],
      child: const MaterialApp(home: CreateTicketPage()),
    ));

    await tester.pumpAndSettle();

    // Dropdown placeholder present
    expect(find.text('Select service'), findsOneWidget);

    // Open the dropdown and verify the service provided by the server is visible
    await tester.tap(find.text('Select service'));
    await tester.pumpAndSettle();

    expect(find.text('HOSTING'), findsOneWidget);
  });
}
