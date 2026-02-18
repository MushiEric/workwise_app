import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/features/support/domain/entities/priority.dart';
import 'package:workwise_erp/features/support/domain/entities/status.dart';
import 'package:workwise_erp/features/support/domain/entities/support_reply.dart';
import 'package:workwise_erp/features/support/domain/entities/support_ticket.dart';
import 'package:workwise_erp/features/support/domain/entities/assigned_user.dart';
import 'package:workwise_erp/features/support/presentation/widgets/ticket_detail_content.dart';

void main() {
  testWidgets('TicketDetailContent builds with default options', (tester) async {
    final ticket = SupportTicket(
      id: 1,
      subject: 'Test',
      ticketCode: 'T-001',
      status: const SupportStatus(id: 1, status: 'Open', color: '#000000'),
      priority: const Priority(id: 1, priority: 'Normal', color: '#000000'),
      replies: const <SupportReply>[],
    );

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(home: Scaffold(body: TicketDetailContent(ticket: ticket))),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(TicketDetailContent), findsOneWidget);
  });

  testWidgets('TicketDetailContent falls back to first option when value not in options', (tester) async {
    final ticket = SupportTicket(
      id: 2,
      subject: 'Fallback test',
      ticketCode: 'T-002',
      status: const SupportStatus(id: 9, status: 'WeirdStatus', color: '#000000'),
      priority: const Priority(id: 9, priority: 'StrangePriority', color: '#000000'),
      replies: const <SupportReply>[],
    );

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(home: Scaffold(body: TicketDetailContent(ticket: ticket))),
    ));
    await tester.pumpAndSettle();

    // Just ensure the widget builds and doesn't throw when provided unknown values.
    expect(find.byType(TicketDetailContent), findsOneWidget);
  });

  testWidgets('shows assigned user and service/category', (tester) async {
    final assignUser = AssignedUser(id: 4, name: 'HERMAN SOLOMON JONES', type: 'operator');

    final ticket = SupportTicket(
      id: 3,
      subject: 'Issue with hosting',
      ticketCode: 'T-200',
      category: 'Billing',
      services: ['HOSTING'],
      assignUser: assignUser,
    );

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(home: Scaffold(body: TicketDetailContent(ticket: ticket))),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Issue with hosting'), findsOneWidget);
    expect(find.text('HOSTING'), findsOneWidget);
    expect(find.text('Billing'), findsOneWidget);
    expect(find.text('HERMAN SOLOMON JONES'), findsOneWidget);
    expect(find.text('operator'), findsOneWidget);
  });

  testWidgets('History tab normalizes numeric createdBy values to strings', (tester) async {
    final now = DateTime.now();

    final reply = SupportReply(
      id: 10,
      message: 'Numeric user test',
      createdBy: 42, // numeric createdBy returned by API in some cases
      createdAt: now.subtract(const Duration(minutes: 5)),
    );

    final ticket = SupportTicket(
      id: 99,
      subject: 'History numeric test',
      ticketCode: 'T-999',
      replies: [reply],
      createdAt: now.subtract(const Duration(days: 1)).toIso8601String(),
      createdBy: 7,
    );

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(home: Scaffold(body: TicketDetailContent(ticket: ticket))),
    ));

    await tester.pumpAndSettle();

    // switch to History tab
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    // should render normalized user strings for both ticket creation and reply
    expect(find.text('User 42'), findsOneWidget);
    expect(find.text('User 7'), findsOneWidget);
  });
}

