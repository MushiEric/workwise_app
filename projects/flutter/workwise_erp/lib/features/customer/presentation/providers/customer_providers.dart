import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/customer_remote_data_source.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/get_customers.dart';
import '../../domain/usecases/get_customer_contacts.dart';
import '../notifier/customers_notifier.dart';
import '../notifier/contacts_notifier.dart';
import '../state/customers_state.dart';
import '../state/contacts_state.dart';

final customerRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return CustomerRemoteDataSource(dio);
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final remote = ref.watch(customerRemoteDataSourceProvider);
  return CustomerRepositoryImpl(remote);
});

final getCustomersUseCaseProvider = Provider((ref) {
  return GetCustomers(ref.watch(customerRepositoryProvider));
});

final getCustomerContactsUseCaseProvider = Provider((ref) {
  return GetCustomerContacts(ref.watch(customerRepositoryProvider));
});

final customersNotifierProvider =
    StateNotifierProvider<CustomersNotifier, CustomersState>((ref) {
  return CustomersNotifier(getCustomers: ref.watch(getCustomersUseCaseProvider));
});

final contactsNotifierProvider =
    StateNotifierProvider<ContactsNotifier, ContactsState>((ref) {
  return ContactsNotifier(
      getContacts: ref.watch(getCustomerContactsUseCaseProvider));
});
