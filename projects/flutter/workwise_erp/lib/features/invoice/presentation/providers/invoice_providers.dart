import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';

import '../../data/datasources/invoice_remote_data_source.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/usecases/get_invoices.dart';
import '../../domain/usecases/get_invoice_by_id.dart';
import '../../domain/usecases/save_invoice.dart';
import '../../domain/usecases/update_invoice.dart';
import '../../domain/usecases/delete_invoice.dart';
import '../notifier/invoice_notifier.dart';
import '../state/invoice_state.dart';

final invoiceRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return InvoiceRemoteDataSource(dio);
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final remote = ref.watch(invoiceRemoteDataSourceProvider);
  return InvoiceRepositoryImpl(remote);
});

final getInvoicesUseCaseProvider = Provider((ref) {
  final repo = ref.watch(invoiceRepositoryProvider);
  return GetInvoices(repo);
});

final getInvoiceByIdUseCaseProvider = Provider((ref) {
  final repo = ref.watch(invoiceRepositoryProvider);
  return GetInvoiceById(repo);
});

final saveInvoiceUseCaseProvider = Provider((ref) {
  final repo = ref.watch(invoiceRepositoryProvider);
  return SaveInvoice(repo);
});

final updateInvoiceUseCaseProvider = Provider((ref) {
  final repo = ref.watch(invoiceRepositoryProvider);
  return UpdateInvoice(repo);
});

final deleteInvoiceUseCaseProvider = Provider((ref) {
  final repo = ref.watch(invoiceRepositoryProvider);
  return DeleteInvoice(repo);
});

final invoiceNotifierProvider =
    StateNotifierProvider<InvoiceNotifier, InvoiceState>((ref) {
  return InvoiceNotifier(
    getInvoices: ref.watch(getInvoicesUseCaseProvider),
    saveInvoice: ref.watch(saveInvoiceUseCaseProvider),
    updateInvoice: ref.watch(updateInvoiceUseCaseProvider),
    deleteInvoice: ref.watch(deleteInvoiceUseCaseProvider),
    getInvoiceById: ref.watch(getInvoiceByIdUseCaseProvider),
  );
});
