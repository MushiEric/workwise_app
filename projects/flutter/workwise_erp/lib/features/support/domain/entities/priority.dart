import 'package:equatable/equatable.dart';

class Priority extends Equatable {
  final int? id;
  final String? priority;
  final String? color;

  const Priority({this.id, this.priority, this.color});

  @override
  List<Object?> get props => [id, priority, color];
}
