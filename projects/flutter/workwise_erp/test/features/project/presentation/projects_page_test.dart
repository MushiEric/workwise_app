import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/features/project/presentation/pages/projects_page.dart';
import 'package:workwise_erp/features/project/presentation/providers/project_providers.dart';
import 'package:workwise_erp/features/project/domain/entities/project.dart';

void main() {
  testWidgets('ProjectsPage shows list from provider', (tester) async {
    final projects = [
      const Project(id: 1, name: 'Alpha', code: 'ALP', progress: 20, tasksCount: 5, sprintsCount: 1),
      const Project(id: 2, name: 'Beta', code: 'BET', progress: 80, tasksCount: 12, sprintsCount: 3),
    ];

    await tester.pumpWidget(ProviderScope(overrides: [
      projectNotifierProvider.overrideWithValue(
        // simple notifier stub that returns loaded state
        StateController(ProjectState.loaded(projects)),
      )
    ], child: const MaterialApp(home: ProjectsPage())));

    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('5 tasks'), findsOneWidget);
  });
}
