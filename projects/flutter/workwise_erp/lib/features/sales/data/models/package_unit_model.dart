import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/package_unit.dart';

part 'package_unit_model.freezed.dart';
part 'package_unit_model.g.dart';

@freezed
class PackageUnitModel with _$PackageUnitModel {
  const factory PackageUnitModel({
    int? id,
    String? name,
    @JsonKey(name: 'short_name') String? shortName,
  }) = _PackageUnitModel;

  factory PackageUnitModel.fromJson(Map<String, dynamic> json) =>
      _$PackageUnitModelFromJson(json);
}

extension PackageUnitModelX on PackageUnitModel {
  PackageUnit toDomain() =>
      PackageUnit(id: id, name: name, shortName: shortName);
}
