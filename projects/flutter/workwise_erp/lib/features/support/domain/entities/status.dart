import 'package:equatable/equatable.dart';

class SupportStatus extends Equatable {
  final int? id;
  final String? status;
  final String? color;

  const SupportStatus({this.id, this.status, this.color});

  @override
  List<Object?> get props => [id, status, color];
}
