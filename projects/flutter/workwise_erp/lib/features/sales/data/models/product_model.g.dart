// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: json['type'] as String?,
      itemType: json['item_type'] as String?,
      salePrice: json['sale_price'] as String?,
      purchasePrice: json['purchase_price'] as String?,
      itemNumber: json['item_number'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'item_type': instance.itemType,
      'sale_price': instance.salePrice,
      'purchase_price': instance.purchasePrice,
      'item_number': instance.itemNumber,
      'category_id': instance.categoryId,
    };
