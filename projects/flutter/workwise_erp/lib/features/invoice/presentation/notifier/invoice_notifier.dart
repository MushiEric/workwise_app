import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_invoices.dart';
import '../state/invoice_state.dart';

class InvoiceNotifier extends StateNotifier<InvoiceState> {
  final GetInvoices getInvoices;
  InvoiceNotifier({required this.getInvoices}) : super(InvoiceState.initial());

  Future<void> loadInvoices() async {
    state = InvoiceState.loading(state.invoices);
    final res = await getInvoices.call();
    res.fold(
      (f) => state = InvoiceState.errorState(f.message, state.invoices),
      (list) => state = InvoiceState.loaded(list),
    );
  }
}
