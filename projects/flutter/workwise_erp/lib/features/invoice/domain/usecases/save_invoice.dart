import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../repositories/invoice_repository.dart';

class SaveInvoice {
  final InvoiceRepository repository;
  SaveInvoice(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> data) async {
    return await repository.saveInvoice(data);
  }
}
