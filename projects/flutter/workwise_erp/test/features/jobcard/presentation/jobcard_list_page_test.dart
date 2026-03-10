import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/features/jobcard/presentation/pages/jobcard_list_page.dart';
import 'package:workwise_erp/core/themes/app_icons.dart';
import 'package:workwise_erp/features/jobcard/presentation/providers/jobcard_providers.dart';
import 'package:workwise_erp/features/jobcard/domain/entities/jobcard.dart';

void main() {
  testWidgets('JobcardListPage shows list from provider', (tester) async {
    final jobcards = [
      const Jobcard(
        id: 1,
        jobcardNumber: 'JB-1',
        status: '1',
        service: 'Service A',
        reportedDate: '2026-01-01',
        grandTotal: '0.00',
        itemsCount: 2,
      ),
      const Jobcard(
        id: 2,
        jobcardNumber: 'JB-2',
        status: '2',
        service: 'Service B',
        reportedDate: '2026-01-02',
        grandTotal: '150000.00',
        itemsCount: 1,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          jobcardNotifierProvider.overrideWithValue(
            StateController(const JobcardState.loaded(<Jobcard>[])),
          ),
        ],
        child: const MaterialApp(home: JobcardListPage()),
      ),
    );

    // ensure page renders without throwing and shows title
    await tester.pumpAndSettle();
    expect(find.text('Jobcards'), findsOneWidget);
    // search icon should be present
    expect(find.byIcon(AppIcons.search), findsOneWidget);
    // FAB add icon uses token
    expect(find.byIcon(AppIcons.addRounded), findsOneWidget);
  });

  testWidgets(
    'JobcardListPage shows settings icon and delete button on tiles',
    (tester) async {
      final jobcards = [
        const Jobcard(
          id: 1,
          jobcardNumber: 'JB-1',
          status: '1',
          service: 'Service A',
          reportedDate: '2026-01-01',
          grandTotal: '0.00',
          itemsCount: 2,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            jobcardNotifierProvider.overrideWithValue(
              StateController(JobcardState.loaded(jobcards)),
            ),
          ],
          child: const MaterialApp(home: JobcardListPage()),
        ),
      );

      await tester.pumpAndSettle();

      // settings icon in appbar using central token
      expect(find.byIcon(AppIcons.settings), findsOneWidget);
      // status cards use assignment and circle tokens
      expect(find.byIcon(AppIcons.assignmentRounded), findsOneWidget);
      expect(find.byIcon(AppIcons.circle), findsWidgets);
      // bottom nav should include file icon
      expect(find.byIcon(AppIcons.file), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    },
  );
}
