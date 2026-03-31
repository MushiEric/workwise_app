import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_invoices.dart';
import '../../domain/usecases/get_invoice_by_id.dart';
import '../../domain/usecases/save_invoice.dart';
import '../../domain/usecases/update_invoice.dart';
import '../../domain/usecases/delete_invoice.dart';
import '../state/invoice_state.dart';

class InvoiceNotifier extends StateNotifier<InvoiceState> {
  final GetInvoices getInvoices;
  final SaveInvoice saveInvoice;
  final UpdateInvoice updateInvoice;
  final DeleteInvoice deleteInvoice;
  final GetInvoiceById getInvoiceById;

  InvoiceNotifier({
    required this.getInvoices,
    required this.saveInvoice,
    required this.updateInvoice,
    required this.deleteInvoice,
    required this.getInvoiceById,
  }) : super(InvoiceState.initial());

  Future<void> loadInvoices() async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await getInvoices.call();
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: f.message),
      (list) => state = state.copyWith(isLoading: false, invoices: list),
    );
  }

  Future<void> fetchInvoiceById(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await getInvoiceById.call(id);
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: f.message),
      (invoice) => state = state.copyWith(isLoading: false, currentInvoice: invoice),
    );
  }

  Future<bool> createInvoice(Map<String, dynamic> data) async {
    state = state.copyWith(isSaving: true, error: null);
    final res = await saveInvoice.call(data);
    return res.fold(
      (f) {
        state = state.copyWith(isSaving: false, error: f.message);
        return false;
      },
      (_) {
        state = state.copyWith(isSaving: false);
        loadInvoices();
        return true;
      },
    );
  }

  Future<bool> editInvoice(String id, Map<String, dynamic> data) async {
    state = state.copyWith(isSaving: true, error: null);
    final res = await updateInvoice.call(id, data);
    return res.fold(
      (f) {
        state = state.copyWith(isSaving: false, error: f.message);
        return false;
      },
      (_) {
        state = state.copyWith(isSaving: false);
        loadInvoices();
        return true;
      },
    );
  }

  Future<bool> removeInvoice(String id) async {
    state = state.copyWith(isDeleting: true, error: null);
    final res = await deleteInvoice.call(id);
    return res.fold(
      (f) {
        state = state.copyWith(isDeleting: false, error: f.message);
        return false;
      },
      (_) {
        state = state.copyWith(isDeleting: false);
        loadInvoices();
        return true;
      },
    );
  }
}
