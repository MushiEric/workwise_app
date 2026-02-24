import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/sales/domain/entities/sales_order.dart';
import 'package:workwise_erp/features/sales/presentation/widgets/order_tile.dart';

void main() {
  testWidgets('OrderTile formats createdAt and handles malformed string', (tester) async {
    // valid ISO string should be formatted
    final orderGood = SalesOrder(createdAt: '2022-01-01T00:00:00.000000Z');

    // invalid string should fall back to "unknown date"
    final orderBad = SalesOrder(createdAt: '00000z');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              OrderTile(order: orderGood),
              OrderTile(order: orderBad),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Jan 1, 2022'), findsOneWidget);
    expect(find.text('unknown date'), findsOneWidget);
  });
}
