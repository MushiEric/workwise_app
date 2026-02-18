import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order_status.dart';

part 'order_status_model.freezed.dart';
part 'order_status_model.g.dart';

@freezed
class OrderStatusModel with _$OrderStatusModel {
  const factory OrderStatusModel({
    int? id,
    @JsonKey(name: 'name') String? name,
    String? color,
  }) = _OrderStatusModel;

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusModelFromJson(json);
}

extension OrderStatusModelX on OrderStatusModel {
  OrderStatus toDomain() => OrderStatus(id: id, name: name, color: color);
}
