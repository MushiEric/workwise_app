import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workwise_erp/features/auth/presentation/pages/login_page.dart';
import 'package:workwise_erp/features/tenant/presentation/pages/workspace_entry_page.dart';
import 'package:workwise_erp/core/storage/token_local_data_source.dart';
import 'package:workwise_erp/core/provider/token_provider.dart';

class _FakeTokenStorage extends TokenLocalDataSource {
  _FakeTokenStorage();

  @override
  Future<String?> readToken() async => 'tok-123';

  @override
  Future<void> saveToken(String token) async {}

  @override
  Future<void> deleteToken() async {}
}

void main() {
  testWidgets('LoginPage redirects to workspace when tenant missing even if token present', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenLocalDataSourceProvider.overrideWithValue(_FakeTokenStorage()),
        ],
        child: MaterialApp(
          routes: {
            '/': (c) => const LoginPage(),
            '/workspace': (c) => const WorkspaceEntryScreen(),
          },
        ),
      ),
    );

    // allow post-frame callbacks to run
    await tester.pumpAndSettle();

    // should be redirected to workspace screen because tenant is not set
    expect(find.byType(WorkspaceEntryScreen), findsOneWidget);
  });
}
