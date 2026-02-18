import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/errors/either.dart';

import 'package:workwise_erp/features/jobcard/presentation/pages/jobcard_settings_page.dart';
import 'package:workwise_erp/features/jobcard/presentation/providers/jobcard_providers.dart';

class _FakeGetConfig {
  Future<Either<dynamic, Map<String, dynamic>>> call() async => Either.right({
        'jobcard_prefix': 'JB -',
        'jobcard_number_format': 'year_number',
        'enable_reminder': 0,
        'approval_status': '7',
      });
}

class _FakeGetSettings {
  Future<Either<dynamic, List>> call() async => Either.right([]);
}

void main() {
  testWidgets('JobcardSettingsPage shows config map when API returns settings object', (tester) async {
    await tester.pumpWidget(
      ProviderScope(overrides: [
        getJobcardConfigUseCaseProvider.overrideWithValue(_FakeGetConfig()),
        getJobcardSettingsUseCaseProvider.overrideWithValue(_FakeGetSettings()),
      ], child: const MaterialApp(home: JobcardSettingsPage())),
    );

    await tester.pumpAndSettle();

    expect(find.text('Jobcard Settings'), findsOneWidget);
    expect(find.text('jobcard_prefix'), findsOneWidget);
    expect(find.text('JB -'), findsOneWidget);
  });
}
