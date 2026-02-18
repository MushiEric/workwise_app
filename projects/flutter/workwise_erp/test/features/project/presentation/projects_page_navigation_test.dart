import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/features/project/presentation/pages/projects_page.dart';
import 'package:workwise_erp/features/project/presentation/pages/project_detail_page.dart';
import 'package:workwise_erp/features/project/presentation/providers/project_providers.dart';
import 'package:workwise_erp/features/project/presentation/state/project_state.dart';
import 'package:workwise_erp/features/project/domain/entities/project.dart';

void main() {
  testWidgets('tapping a project navigates to detail and passes Project object', (tester) async {
    final sample = const Project(id: 42, name: 'Hello Project', code: 'HP-42');

    await tester.pumpWidget(ProviderScope(overrides: [
      projectNotifierProvider.overrideWithValue(StateController(ProjectState.loaded([sample]))),
    ], child: MaterialApp(
      routes: {
        '/': (ctx) => const ProjectsPage(),
        '/projects/detail': (ctx) => const ProjectDetailPage(),
      },
    )));

    await tester.pumpAndSettle();

    expect(find.text('Hello Project'), findsOneWidget);

    await tester.tap(find.text('Hello Project'));
    await tester.pumpAndSettle();

    // ProjectDetailPage should display project name passed via arguments
    expect(find.textContaining('Hello Project'), findsWidgets);
  });
}
