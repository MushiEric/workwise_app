import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../repositories/invoice_repository.dart';

class DeleteInvoice {
  final InvoiceRepository repository;
  DeleteInvoice(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteInvoice(id);
  }
}
