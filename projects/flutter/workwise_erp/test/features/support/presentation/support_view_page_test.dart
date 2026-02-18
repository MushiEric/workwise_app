import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/support/domain/entities/support_ticket.dart';
import 'package:workwise_erp/features/support/domain/entities/customer_summary.dart';
import 'package:workwise_erp/features/support/domain/repositories/support_repository.dart';
import 'package:workwise_erp/features/support/domain/entities/status.dart';
import 'package:workwise_erp/features/support/domain/entities/priority.dart';
import 'package:workwise_erp/features/support/domain/entities/support_location.dart';
import 'package:workwise_erp/features/support/domain/entities/support_supervisor.dart';
import 'package:workwise_erp/features/support/domain/entities/support_category.dart';
import 'package:workwise_erp/features/support/domain/entities/support_department.dart';
import 'package:workwise_erp/features/support/domain/usecases/delete_support_ticket.dart';
import 'package:workwise_erp/features/support/presentation/pages/support_view_page.dart';
import 'package:workwise_erp/features/support/presentation/providers/support_providers.dart';
import 'package:workwise_erp/features/support/domain/entities/support_create_params.dart';
import 'package:workwise_erp/features/support/domain/entities/support_service.dart';

class _FakeRepo implements SupportRepository {
  @override
  Future<Either<Failure, void>> changeTicketPriority({required int ticketId, required int priorityId}) async => Either.right(null);

  @override
  Future<Either<Failure, void>> changeTicketStatus({required int ticketId, required int statusId}) async => Either.right(null);

  @override
  Future<Either<Failure, List<SupportTicket>>> getTickets() async => Either.right(<SupportTicket>[]);

  @override
  Future<Either<Failure, List<SupportStatus>>> getStatuses() async => Either.right(<SupportStatus>[]);

  @override
  Future<Either<Failure, List<Priority>>> getPriorities() async => Either.right(<Priority>[]);

  @override
  Future<Either<Failure, List<SupportCategory>>> getCategories() async => Either.right(<SupportCategory>[]);

  @override
  Future<Either<Failure, List<SupportDepartment>>> getDepartments() async => Either.right(<SupportDepartment>[]);

  @override
  Future<Either<Failure, List<SupportLocation>>> getLocations() async => Either.right(<SupportLocation>[]);

  @override
  Future<Either<Failure, List<SupportSupervisor>>> getSupervisors() async => Either.right(<SupportSupervisor>[]);

  @override
  Future<Either<Failure, List<SupportService>>> getServices() async => Either.right(<SupportService>[]);

  @override
  Future<Either<Failure, void>> deleteTicket({required int ticketId}) async => Either.right(null);

  @override
  Future<Either<Failure, void>> createTicket({required SupportCreateParams params}) async => Either.right(null);
}

void main() {
  testWidgets('delete flow from SupportViewPage shows confirmation and deletes without crash', (tester) async {
    final ticket = SupportTicket(
      id: 1,
      subject: 'Test ticket',
      ticketCode: 'T-1',
      customer: const CustomerSummary(id: 1, name: 'Acme'),
    );

    final fakeRepo = _FakeRepo();
    final deleteUseCase = DeleteSupportTicket(fakeRepo);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        deleteSupportTicketUseCaseProvider.overrideWithValue(deleteUseCase),
      ],
      child: MaterialApp(home: Scaffold(body: SupportViewPage(ticket: ticket))),
    ));

    await tester.pumpAndSettle();

    // Open app-bar menu
    expect(find.byIcon(Icons.more_vert_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle();

    // Select "More..." which opens the bottom sheet with Delete option
    expect(find.text('More...'), findsOneWidget);
    await tester.tap(find.text('More...'));
    await tester.pumpAndSettle();

    // Tap Delete Ticket in the bottom sheet
    expect(find.text('Delete Ticket'), findsOneWidget);
    await tester.tap(find.text('Delete Ticket'));
    await tester.pumpAndSettle();

    // Confirmation modal should appear — tap the confirm "Delete" button
    final deleteButton = find.widgetWithText(ElevatedButton, 'Delete');
    expect(deleteButton, findsOneWidget);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Should show snackbar confirming deletion
    expect(find.text('Ticket deleted'), findsOneWidget);
  });
}
