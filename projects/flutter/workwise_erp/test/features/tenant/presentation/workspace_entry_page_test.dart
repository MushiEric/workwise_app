import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workwise_erp/features/tenant/presentation/pages/workspace_entry_page.dart';
import 'package:workwise_erp/core/models/tenant.dart';
import 'package:workwise_erp/core/storage/tenant_local_data_source.dart';
import 'package:workwise_erp/core/provider/tenant_provider.dart';

class _MockDio extends Mock implements Dio {}

class _FakeStorage implements TenantLocalDataSource {
  String? saved;

  @override
  Future<void> clearTenant() async => saved = null;

  @override
  Future<String?> readTenant() async => saved;

  @override
  Future<void> saveTenant(String apiBase) async => saved = apiBase;
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  testWidgets('WorkspaceEntry accepts subdomain and persists normalized API base', (tester) async {
    final mockDio = _MockDio();
    // Skipping /health validation because there is no health endpoint available in the current environment.
    // Re-enable the following mock when a /health endpoint is provided.
    // when(() => mockDio.get('/health')).thenAnswer((_) async => Response(requestOptions: RequestOptions(path: '/health'), statusCode: 200, data: {}));

    final storage = _FakeStorage();
    final container = ProviderContainer();

    await tester.pumpWidget(ProviderScope(
      parent: container,
      overrides: [
        tenantLocalDataSourceProvider.overrideWithValue(storage),
      ],
      child: MaterialApp(
        initialRoute: '/entry',
        routes: {
          '/': (c) => const SizedBox.shrink(),
          '/entry': (c) => WorkspaceEntryScreen(dioFactory: (base) => mockDio),
        },
      ),
    ));

    // enter only the subdomain
    await tester.enterText(find.byType(TextFormField), 'staging');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // saved value should be normalized to https://staging.workwise.africa/api
    const expected = 'https://staging.workwise.africa/api';
    expect(storage.saved, expected);

    // provider should be updated
    final tenant = container.read(tenantProvider);
    expect(tenant, isA<Tenant>());
    expect(tenant!.baseUrl, expected);
  });
}
