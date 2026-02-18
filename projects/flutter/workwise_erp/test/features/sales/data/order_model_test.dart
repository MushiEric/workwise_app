import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/sales/data/models/order_model.dart';

void main() {
  test('OrderModel.fromJson -> toDomain maps main fields', () {
    final json = {
      'id': 132,
      'order_number': '2026/054194',
      'customer_id': 3,
      'amount': 200001160,
      'payment_status': 1,
      'customer': {
        'id': 3,
        'name': 'MARY ASSENGA',
        'email': 'maryassenga@gmail.com',
        'contact': '0778897013',
      },
      'user': {
        'id': 3,
        'name': 'Eric Prosper',
        'email': 'ericprosper603@gmail.com',
      },
      'status_row': {'id': 1, 'name': 'DRAFT', 'color': '#000000'},
      'payment_status_row': {'id': 1, 'name': 'unpaid', 'color': '#FF6347'},
      'items': [
        {
          'id': 163,
          'order_id': '132',
          'item_id': '1',
          'price': '100000.58',
          'quantity': '2000',
          'product': {
            'id': 1,
            'name': 'Nike Watch',
            'sale_price': '100000.58',
            'item_number': 'AEZ107',
          },
          'package_unit': {'id': 1, 'name': 'KILOGRAM', 'short_name': 'KG'},
        },
      ],
      'truck_list': [
        {
          'id': 130,
          'order_id': '132',
          'vehicle_name': 'TRUCK',
          'vehicle_plate_number': 'T 123 EFB',
          'vehicle_trailer_number': 'TRAIL',
          'driver_name': 'CLAUDE',
          'driver_phone': '0789898989',
          'driver_license_number': 'DL123',
          'checkin_weight': '1000.00',
          'checkin_weight_unit': '1',
          'checkin_datetime': '2026-02-14T07:30:37.000000Z',
          'checkin_status': 'completed',
          'checkout_weight': '3000.00',
          'checkout_weight_unit': '1',
          'checkout_datetime': '2026-02-14T07:31:12.000000Z',
          'checkout_status': 'completed',
          'net_weight': '2000.00',
          'net_weight_unit': '1',
        },
      ],
    };

    final model = OrderModel.fromJson(json);
    final domain = model.toDomain();

    expect(domain.id, 132);
    expect(domain.orderNumber, '2026/054194');
    expect(domain.amount, 200001160);
    expect(domain.customer?.name, 'MARY ASSENGA');
    expect(domain.user?.name, 'Eric Prosper');
    expect(domain.statusRow?.name, 'DRAFT');
    expect(domain.paymentStatusRow?.name, 'unpaid');
    expect(domain.items?.first.product?.name, 'Nike Watch');
    final truck = domain.truckList?.first;
    expect(truck?.vehicleName, 'TRUCK');
    expect(truck?.vehiclePlateNumber, 'T 123 EFB');
    expect(truck?.driverName, 'CLAUDE');
    expect(truck?.driverPhone, '0789898989');
    expect(truck?.checkinWeight, '1000.00');
    expect(truck?.checkoutWeight, '3000.00');
    expect(truck?.checkinStatus, 'completed');
    expect(truck?.checkoutStatus, 'completed');
  });
}
