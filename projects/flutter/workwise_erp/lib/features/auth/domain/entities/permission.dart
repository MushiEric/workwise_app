import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  final int? id;
  final String? name;

  const Permission({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
