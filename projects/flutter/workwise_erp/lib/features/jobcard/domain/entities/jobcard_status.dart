import 'package:equatable/equatable.dart';

class JobcardStatus extends Equatable {
  final int? id;
  final String? name;
  final String? color;

  const JobcardStatus({this.id, this.name, this.color});

  @override
  List<Object?> get props => [id, name, color];
}
