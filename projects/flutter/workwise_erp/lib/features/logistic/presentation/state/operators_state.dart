import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/operator.dart';

part 'operators_state.freezed.dart';

@freezed
class OperatorsState with _$OperatorsState {
  const factory OperatorsState.initial() = _Initial;
  const factory OperatorsState.loading() = _Loading;
  const factory OperatorsState.loaded(List<Operator> operators) = _Loaded;
  const factory OperatorsState.error(String message) = _Error;
}
