import '../../domain/entities/invoice.dart';

class InvoiceState {
  final bool isLoading;
  final String? error;
  final List<Invoice> invoices;

  InvoiceState({required this.isLoading, required this.invoices, this.error});

  factory InvoiceState.initial() =>
      InvoiceState(isLoading: false, invoices: []);
  factory InvoiceState.loading(List<Invoice> prev) =>
      InvoiceState(isLoading: true, invoices: prev);
  factory InvoiceState.loaded(List<Invoice> list) =>
      InvoiceState(isLoading: false, invoices: list);
  factory InvoiceState.errorState(String message, List<Invoice> prev) =>
      InvoiceState(isLoading: false, invoices: prev, error: message);
}
