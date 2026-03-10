import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workwise_erp/features/jobcard/presentation/pages/jobcard_detail_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workwise_erp/features/jobcard/presentation/notifier/jobcard_detail_notifier.dart';
import 'package:workwise_erp/features/jobcard/presentation/providers/jobcard_detail_providers.dart';
import 'package:workwise_erp/features/jobcard/domain/entities/jobcard_detail.dart';

void main() {
  testWidgets('JobcardDetailPage shows tabs and Overview/Repairs content', (
    tester,
  ) async {
    final jobcard = JobcardDetail(
      id: 20,
      jobcardNumber: 'JB-2025/124016',
      service: 'NEEDING BRAKES',
      status: '2',
      reportedDate: '2025-11-14 15:40:03',
      dispatchedDate: '2025-11-21 15:40:00',
      relatedTo: 'Vehicle',
      receiverName: 'John Doe',
      technicianId: '["17"]',
      grandTotal: '750000.00',
      notes: 'Please replace brake pads',
      items: [
        {'item_name': 'SINKS', 'qty': 5, 'item_description': 'Test item'},
      ],
      logs: [
        {
          'id': 1,
          'status': '1',
          'created_at': '2025-11-14T12:41:48.000000Z',
          'status_row': {'id': 1, 'name': 'Open'},
        },
        {
          'id': 2,
          'status': '2',
          'created_at': '2025-11-14T13:09:14.000000Z',
          'status_row': {'id': 2, 'name': 'In progress'},
        },
      ],
      statusRow: {'id': 2, 'name': 'In progress'},
    );

    final container = ProviderContainer();
    // pre-populate notifier state in the container
    container.read(jobcardDetailNotifierProvider.notifier).state =
        JobcardDetailState.loaded(jobcard);

    await tester.pumpWidget(
      ScreenUtilInit(
        builder: () => UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: JobcardDetailPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tabs should be present
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Repairs&Replacement'), findsOneWidget);
    expect(find.text('Logs'), findsOneWidget);

    // Overview tab shows jobcard number and related fields
    expect(find.text('Jobcard Number'), findsOneWidget);
    expect(find.text('JB-2025/124016').first, findsWidgets);
    expect(find.text('Related to'), findsOneWidget);
    expect(find.text('Vehicle'), findsOneWidget);
    expect(find.text('Receiver'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Recommendation'), findsOneWidget);
    expect(find.text('Please replace brake pads'), findsOneWidget);

    // Switch to Repairs&Replacement tab and assert item displayed
    await tester.tap(find.text('Repairs&Replacement'));
    await tester.pumpAndSettle();
    expect(find.text('SINKS'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });
}
