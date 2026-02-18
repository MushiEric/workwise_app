import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/features/jobcard/presentation/widgets/jobcard_tile.dart';
import 'package:workwise_erp/features/jobcard/domain/entities/jobcard.dart';

void main() {
  testWidgets('JobcardTile prefers status_row color when present', (tester) async {
    final jc = Jobcard(
      id: 1,
      jobcardNumber: 'JB-1',
      status: '2',
      service: 'Service A',
      reportedDate: '2026-01-01',
      grandTotal: '0.00',
      itemsCount: 1,
      statusRow: {'id': 2, 'name': 'In progress', 'color': '#457af7'},
    );

    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: Scaffold(body: JobcardTile(jobcard: jc)))));
    await tester.pumpAndSettle();

    // Status text should be colored with parsed color
    final statusText = find.text('In progress');
    expect(statusText, findsOneWidget);
    final textWidget = tester.widget<Text>(statusText);
    expect(textWidget.style?.color, const Color(0xFF457AF7));
  });
}
