import '../../domain/entities/invoice.dart';

class InvoiceState {
  final bool isLoading;
  final bool isSaving;
  final bool isDeleting;
  final String? error;
  final List<Invoice> invoices;
  final Invoice? currentInvoice;

  InvoiceState({
    required this.isLoading,
    required this.invoices,
    this.isSaving = false,
    this.isDeleting = false,
    this.error,
    this.currentInvoice,
  });

  factory InvoiceState.initial() => InvoiceState(isLoading: false, invoices: []);

  InvoiceState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isDeleting,
    String? error,
    List<Invoice>? invoices,
    Invoice? currentInvoice,
  }) {
    return InvoiceState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      error: error,
      invoices: invoices ?? this.invoices,
      currentInvoice: currentInvoice ?? this.currentInvoice,
    );
  }
}
