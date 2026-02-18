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

  const OrderItem({
    this.id,
    this.orderId,
    this.itemId,
    this.price,
    this.quantity,
    this.product,
    this.packageUnit,
    this.loadingInstruction,
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
  ];
}
