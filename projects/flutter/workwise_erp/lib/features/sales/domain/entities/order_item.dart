import 'package:equatable/equatable.dart';

import 'product_summary.dart';
import 'package_unit.dart';

class OrderItem extends Equatable {
  final int? id;
  final int? orderId;
  final int? itemId;
  final String? price;
  final String? quantity;
  final ProductSummary? product;
  final PackageUnit? packageUnit;
  final String? loadingInstruction;
  final String? tax;
  final String? discount;
  final String? duration;
  final String? durationUnit;

  const OrderItem({
    this.id,
    this.orderId,
    this.itemId,
    this.price,
    this.quantity,
    this.product,
    this.packageUnit,
    this.loadingInstruction,
    this.tax,
    this.discount,
    this.duration,
    this.durationUnit,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    itemId,
    price,
    quantity,
    product,
    packageUnit,
    loadingInstruction,
    tax,
    discount,
    duration,
    durationUnit,
  ];
}
