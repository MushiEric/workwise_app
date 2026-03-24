import 'package:equatable/equatable.dart';

class ProductSummary extends Equatable {
  final int? id;
  final String? name;
  final String? type;
  final String? itemType;
  final String? itemNumber;
  final String? salePrice;
  final String? purchasePrice;

  const ProductSummary({
    this.id,
    this.name,
    this.type,
    this.itemType,
    this.itemNumber,
    this.salePrice,
    this.purchasePrice,
  });

  @override
  List<Object?> get props => [id, name, type, itemType, itemNumber, salePrice, purchasePrice];
}
