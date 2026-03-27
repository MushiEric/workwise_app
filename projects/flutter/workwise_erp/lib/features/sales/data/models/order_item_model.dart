import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order_item.dart';
import 'product_model.dart';
import 'package_unit_model.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    int? id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'item_id') String? itemId,
    String? price,
    String? quantity,
    @JsonKey(name: 'package_unit') PackageUnitModel? packageUnit,
    ProductModel? product,
    @JsonKey(name: 'loading_instruction') String? loadingInstruction,
    String? tax,
    String? discount,
    String? duration,
    @JsonKey(name: 'duration_unit') String? durationUnit,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}

extension OrderItemModelX on OrderItemModel {
  OrderItem toDomain() => OrderItem(
    id: id,
    orderId: int.tryParse(orderId ?? ''),
    itemId: int.tryParse(itemId ?? ''),
    price: price,
    quantity: quantity,
    product: product?.toDomain(),
    packageUnit: packageUnit?.toDomain(),
    loadingInstruction: loadingInstruction,
    tax: tax,
    discount: discount,
    duration: duration,
    durationUnit: durationUnit,
  );
}
