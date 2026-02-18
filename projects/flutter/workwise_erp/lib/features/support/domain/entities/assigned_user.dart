import 'package:equatable/equatable.dart';

class AssignedUser extends Equatable {
  final int? id;
  final String? name;
  final String? type;

  const AssignedUser({this.id, this.name, this.type});

  @override
  List<Object?> get props => [id, name, type];
}
