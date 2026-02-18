import 'package:equatable/equatable.dart';

class PackageUnit extends Equatable {
  final int? id;
  final String? name;
  final String? shortName;

  const PackageUnit({this.id, this.name, this.shortName});

  @override
  List<Object?> get props => [id, name, shortName];
}
