import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/asset.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

@freezed
class AssetModel with _$AssetModel {
  const factory AssetModel({
    int? id,
    @JsonKey(name: 'asset_id') String? assetId,
    String? type,
    String? name,
    @JsonKey(name: 'registration_number') String? registrationNumber,
    String? model,
    String? image,
    String? year,
    String? status,
    @JsonKey(name: 'is_available') int? isAvailable,
    @JsonKey(name: 'is_active') int? isActive,
    @JsonKey(name: 'has_gps') bool? hasGps,
    String? vin,
    String? make,
    @JsonKey(name: 'company') String? company,
    @JsonKey(name: 'fuel_consuption') num? fuelConsumption,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _AssetModel;

  factory AssetModel.fromJson(Map<String, dynamic> json) => _$AssetModelFromJson(json);
}

extension AssetModelX on AssetModel {
  Asset toDomain() => Asset(
        id: id,
        assetId: assetId,
        type: type,
        name: name,
        registrationNumber: registrationNumber,
        model: model,
        image: image,
        year: year,
        status: status,
        isAvailable: (isAvailable == null) ? null : (isAvailable == 1),
        isActive: (isActive == null) ? null : (isActive == 1),
        hasGps: hasGps ?? false,
        vin: vin,
        make: make,
        company: company,
        fuelConsumption: fuelConsumption,
        createdAt: createdAt,
      );
}
