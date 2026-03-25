import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_summary.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    int? id,
    String? name,
    String? type,
    @JsonKey(name: 'item_type') String? itemType,
    @JsonKey(name: 'sale_price') String? salePrice,
    @JsonKey(name: 'purchase_price') String? purchasePrice,
    @JsonKey(name: 'item_number') String? itemNumber,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'unit_id') int? unitId,
    @JsonKey(name: 'unit_name') String? unitName,
    @JsonKey(name: 'tax_id') int? taxId,
    @JsonKey(name: 'tax_name') String? taxName,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

extension ProductModelX on ProductModel {
  ProductSummary toDomain() => ProductSummary(
    id: id,
    name: name,
    type: type,
    itemType: itemType,
    itemNumber: itemNumber,
    salePrice: salePrice,
    purchasePrice: purchasePrice,
    unitId: unitId,
    unitName: unitName,
    taxId: taxId,
    taxName: taxName,
  );
}
