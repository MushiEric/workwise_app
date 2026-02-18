import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/sales/presentation/pages/sales_view_page.dart';
import 'package:workwise_erp/features/sales/domain/entities/sales_order.dart';

void main() {
  testWidgets('SalesViewPage shows tabs and overview', (tester) async {
    final order = SalesOrder(
      id: 1,
      orderNumber: '2026/054194',
      amount: 12345,
      truckList: [
        Truck(
          id: 130,
          vehicleName: 'TRUCK',
          vehiclePlateNumber: 'T 123 EFB',
          driverName: 'CLAUDE',
          driverPhone: '0789898989',
          checkinWeight: '1000.00',
          checkoutWeight: '3000.00',
          netWeight: '2000.00',
          checkinStatus: 'completed',
          checkoutStatus: 'completed',
          checkinDatetime: '2026-02-14T07:30:37.000000Z',
          checkoutDatetime: '2026-02-14T07:31:12.000000Z',
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp(home: SalesViewPage(order: order)));
    await tester.pumpAndSettle();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Items'), findsOneWidget);
    expect(find.text('Status Log'), findsOneWidget);
    expect(find.text('Print Logs'), findsOneWidget);
    expect(find.text('Truck List'), findsOneWidget);
    expect(find.text('Loading instruction'), findsOneWidget);

    // verify overview content shows order number
    expect(find.text('2026/054194'), findsOneWidget);

    // switch to Truck List tab and validate truck details
    await tester.tap(find.text('Truck List'));
    await tester.pumpAndSettle();

    expect(find.text('CLAUDE'), findsOneWidget);
    expect(find.textContaining('T 123 EFB'), findsOneWidget);
    expect(find.textContaining('1,000'), findsOneWidget);
  });
}
