import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

class GetInvoiceById {
  final InvoiceRepository repository;
  GetInvoiceById(this.repository);

  Future<Either<Failure, Invoice>> call(String id) async {
    return await repository.getInvoiceById(id);
  }
}
