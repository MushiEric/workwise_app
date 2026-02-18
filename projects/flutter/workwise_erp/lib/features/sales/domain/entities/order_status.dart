import 'package:equatable/equatable.dart';

class OrderStatus extends Equatable {
  final int? id;
  final String? name;
  final String? color;

  const OrderStatus({this.id, this.name, this.color});

  @override
  List<Object?> get props => [id, name, color];
}
