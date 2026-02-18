import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer_summary.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    int? id,
    String? name,
    String? email,
    String? phone,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);
}

extension CustomerModelX on CustomerModel {
  CustomerSummary toDomain() => CustomerSummary(id: id, name: name, email: email, phone: phone);
}
