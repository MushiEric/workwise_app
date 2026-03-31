import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';

import '../../data/datasources/invoice_remote_data_source.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/usecases/get_invoices.dart';
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

final invoiceNotifierProvider =
    StateNotifierProvider<InvoiceNotifier, InvoiceState>((ref) {
      final uc = ref.watch(getInvoicesUseCaseProvider);
      return InvoiceNotifier(getInvoices: uc);
    });
