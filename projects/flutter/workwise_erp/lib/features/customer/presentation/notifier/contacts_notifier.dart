import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_customer_contacts.dart';
import '../state/contacts_state.dart';

class ContactsNotifier extends StateNotifier<ContactsState> {
  final GetCustomerContacts _getContacts;
  int? _loadedForId;

  ContactsNotifier({required GetCustomerContacts getContacts})
      : _getContacts = getContacts,
        super(const ContactsState.initial());

  Future<void> loadContacts(int customerId, String customerName) async {
    // Skip if already loaded for the same customer
    if (_loadedForId == customerId &&
        state.maybeWhen(loaded: (_) => true, orElse: () => false)) {
      return;
    }
    _loadedForId = customerId;
    state = const ContactsState.loading();
    final res = await _getContacts.call(customerId);
    res.fold(
      (f) => state = ContactsState.error(f.message),
      (list) => state = ContactsState.loaded(
        list.map((c) => c.copyWith(customerName: customerName)).toList(),
      ),
    );
  }

  void reset() {
    _loadedForId = null;
    state = const ContactsState.initial();
  }
}
