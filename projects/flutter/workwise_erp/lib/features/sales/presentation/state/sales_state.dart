import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/sales_order.dart';

part 'sales_state.freezed.dart';

@freezed
class SalesState with _$SalesState {
  const factory SalesState.initial() = _Initial;
  const factory SalesState.loading() = _Loading;
  const factory SalesState.loaded(
    List<SalesOrder> orders, {
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
  }) = _Loaded;
  const factory SalesState.error(String message) = _Error;
}
