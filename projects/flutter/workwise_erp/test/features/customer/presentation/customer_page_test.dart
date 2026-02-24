import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/customer/presentation/pages/customer_page.dart';
import 'package:workwise_erp/features/customer/presentation/state/customers_state.dart';
import 'package:workwise_erp/features/customer/presentation/providers/customer_providers.dart';

class FakeCustomersNotifier extends CustomersNotifier {
  // pass a dummy GetCustomers since we won't call it
  FakeCustomersNotifier()
      : super(getCustomers: throw UnimplementedError());

  void emit(CustomersState s) => state = s;
}

void main() {
  testWidgets('shows loading dialog when customers are loading', (tester) async {
    final fake = FakeCustomersNotifier();
    final container = ProviderContainer(overrides: [
      customersNotifierProvider.overrideWith((ref) => fake),
    ]);

    await tester.pumpWidget(ProviderScope(
      parent: container,
      child: const MaterialApp(home: CustomerPage()),
    ));

    // initially no loading dialog
    expect(find.text('Fetching customers...'), findsNothing);

    fake.emit(const CustomersState.loading());
    await tester.pumpAndSettle();

    expect(find.text('Fetching customers...'), findsOneWidget);

    fake.emit(const CustomersState.loaded([]));
    await tester.pumpAndSettle();

    expect(find.text('Fetching customers...'), findsNothing);
  });
}
