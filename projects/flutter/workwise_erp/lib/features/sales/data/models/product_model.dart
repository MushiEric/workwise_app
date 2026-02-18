import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_summary.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    int? id,
    String? name,
    @JsonKey(name: 'sale_price') String? salePrice,
    @JsonKey(name: 'purchase_price') String? purchasePrice,
    @JsonKey(name: 'item_number') String? itemNumber,
    @JsonKey(name: 'category_id') int? categoryId,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

extension ProductModelX on ProductModel {
  ProductSummary toDomain() => ProductSummary(
    id: id,
    name: name,
    itemNumber: itemNumber,
    salePrice: salePrice,
    purchasePrice: purchasePrice,
  );
}
