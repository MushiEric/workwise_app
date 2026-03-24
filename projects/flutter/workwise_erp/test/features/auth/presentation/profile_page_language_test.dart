import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/features/auth/domain/entities/user.dart';
import 'package:workwise_erp/features/auth/domain/entities/role.dart';
import 'package:workwise_erp/features/auth/presentation/pages/profile_page.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/core/provider/locale_provider.dart';

void main() {
  testWidgets('language selection persists locally and updates app locale', (tester) async {
    SharedPreferences.setMockInitialValues({});

    const user = User(id: 1, name: 'Test User', lang: 'en');

    final container = ProviderContainer(overrides: [
      // Provide a current user so ProfilePage shows the initial language
      currentUserProvider.overrideWithValue(FutureProvider((ref) async => const Either.right(user))),
    ]);

    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const MaterialApp(home: Scaffold(body: ProfilePage()))));
    await tester.pumpAndSettle();

    // open settings
    final settings = find.byIcon(Icons.settings_rounded);
    expect(settings, findsOneWidget);
    await tester.tap(settings);
    await tester.pumpAndSettle();

    // Language tile should show English initially
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    // Open language selector
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    // Selector has options
    expect(find.text('Swahili'), findsOneWidget);

    // Select Swahili
    await tester.tap(find.text('Swahili'));
    await tester.pumpAndSettle();

    // provider should be updated
    expect(container.read(appLocaleProvider), 'sw');

    // Expect success feedback and updated subtitle
    expect(find.textContaining('Language updated successfully'), findsOneWidget);
    expect(find.text('Swahili'), findsWidgets);
  });

  testWidgets('shows role from user.roles (or backend `type`)', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final user = User(id: 2, name: 'Role User', lang: 'en', roles: [const Role(id: 1, name: 'operator')]);

    final container = ProviderContainer(overrides: [
      currentUserProvider.overrideWithValue(FutureProvider((ref) async => Either.right(user))),
    ]);

    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const MaterialApp(home: Scaffold(body: ProfilePage()))));
    await tester.pumpAndSettle();

    // role badge should display the role name from roles[0]
    expect(find.text('operator'), findsOneWidget);
  });
}
