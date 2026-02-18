// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      id: (json['id'] as num?)?.toInt(),
      orderId: json['order_id'] as String?,
      itemId: json['item_id'] as String?,
      price: json['price'] as String?,
      quantity: json['quantity'] as String?,
      packageUnit: json['package_unit'] == null
          ? null
          : PackageUnitModel.fromJson(
              json['package_unit'] as Map<String, dynamic>,
            ),
      product: json['product'] == null
          ? null
          : ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      loadingInstruction: json['loading_instruction'] as String?,
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
  _$OrderItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'order_id': instance.orderId,
  'item_id': instance.itemId,
  'price': instance.price,
  'quantity': instance.quantity,
  'package_unit': instance.packageUnit,
  'product': instance.product,
  'loading_instruction': instance.loadingInstruction,
};
