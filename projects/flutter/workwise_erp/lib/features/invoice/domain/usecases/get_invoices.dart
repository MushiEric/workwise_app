import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/invoice_repository.dart';
import '../entities/invoice.dart';

class GetInvoices {
  final InvoiceRepository repository;
  GetInvoices(this.repository);

  Future<Either<Failure, List<Invoice>>> call() async {
    return repository.getInvoices();
  }
}
