import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/features/support/domain/entities/priority.dart';
import 'package:workwise_erp/features/support/domain/entities/status.dart';
import 'package:workwise_erp/features/support/domain/entities/support_ticket.dart';
import 'package:workwise_erp/features/support/domain/entities/customer_summary.dart';
import 'package:workwise_erp/features/support/domain/usecases/get_support_priorities.dart';
import 'package:workwise_erp/features/support/domain/usecases/get_support_tickets.dart';
import 'package:workwise_erp/features/support/domain/entities/support_location.dart';
import 'package:workwise_erp/features/support/domain/entities/support_supervisor.dart';
import 'package:workwise_erp/features/support/presentation/pages/support_list_page.dart';
import 'package:workwise_erp/features/support/domain/repositories/support_repository.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/support/presentation/providers/support_providers.dart';
import 'package:workwise_erp/features/support/domain/entities/support_category.dart';
import 'package:workwise_erp/features/support/domain/entities/support_department.dart';
import 'package:workwise_erp/features/support/domain/entities/support_create_params.dart';import 'package:workwise_erp/features/support/domain/entities/support_service.dart';
class _FakeSupportRepository implements SupportRepository {
  final List<SupportTicket> tickets;
  final List<Priority> priorities;

  _FakeSupportRepository({required this.tickets, required this.priorities});

  @override
  Future<Either<Failure, List<SupportTicket>>> getTickets() async => Either.right(tickets);

  @override
  Future<Either<Failure, List<Priority>>> getPriorities() async => Either.right(priorities);

  @override
  Future<Either<Failure, List<SupportStatus>>> getStatuses() async => Either.right(<SupportStatus>[]);

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
  Future<Either<Failure, void>> changeTicketPriority({required int ticketId, required int priorityId}) async => Either.right(null);

  @override
  Future<Either<Failure, void>> changeTicketStatus({required int ticketId, required int statusId}) async => Either.right(null);

  @override
  Future<Either<Failure, void>> deleteTicket({required int ticketId}) async => Either.right(null);

  @override
  Future<Either<Failure, void>> createTicket({required SupportCreateParams params}) async => Either.right(null);
}

void main() {
  testWidgets('SupportListPage builds dynamic priority tabs and filters tickets by selected priority', (tester) async {
    final highPriority = const Priority(id: 1, priority: 'High', color: '#FF0000');
    final lowPriority = const Priority(id: 2, priority: 'Low', color: '#00FF00');

    final ticketHigh = SupportTicket(
      id: 1,
      subject: 'High priority issue',
      ticketCode: 'T-100',
      status: const SupportStatus(id: 1, status: 'Open', color: '#000000'),
      priority: highPriority,
      customer: const CustomerSummary(id: 1, name: 'Acme'),
    );

    final ticketLow = SupportTicket(
      id: 2,
      subject: 'Low priority issue',
      ticketCode: 'T-101',
      status: const SupportStatus(id: 1, status: 'Open', color: '#000000'),
      priority: lowPriority,
    );

    final repo = _FakeSupportRepository(tickets: [ticketHigh, ticketLow], priorities: [highPriority, lowPriority]);
    final getTickets = GetSupportTickets(repo);
    final getPriorities = GetSupportPriorities(repo);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        // override the use-cases so the page loads our fake data
        getSupportTicketsUseCaseProvider.overrideWithValue(getTickets),
        getSupportPrioritiesUseCaseProvider.overrideWithValue(getPriorities),
      ],
      child: MaterialApp(home: Scaffold(body: SupportListPage())),
    ));

    // allow async loads to complete
    await tester.pumpAndSettle();

    // Expect dynamic tabs created from priorities
    expect(find.text('All'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
    expect(find.text('Low'), findsOneWidget);

    // Both tickets should be visible initially
    expect(find.text('High priority issue'), findsOneWidget);
    expect(find.text('Low priority issue'), findsOneWidget);

    // Tap on the 'High' tab and expect filtering to show only the high-priority ticket
    await tester.tap(find.text('High'));
    await tester.pumpAndSettle();

    expect(find.text('High priority issue'), findsOneWidget);
    expect(find.text('Low priority issue'), findsNothing);
  });
}
