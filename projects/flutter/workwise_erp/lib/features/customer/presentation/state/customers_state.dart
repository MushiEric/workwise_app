import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer.dart';

part 'customers_state.freezed.dart';

@freezed
class CustomersState with _$CustomersState {
  const factory CustomersState.initial() = _Initial;
  const factory CustomersState.loading() = _Loading;
  const factory CustomersState.loaded(List<Customer> customers) = _Loaded;
  const factory CustomersState.error(String message) = _Error;
}
