import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../repositories/invoice_repository.dart';

class UpdateInvoice {
  final InvoiceRepository repository;
  UpdateInvoice(this.repository);

  Future<Either<Failure, void>> call(String id, Map<String, dynamic> data) async {
    return await repository.updateInvoice(id, data);
  }
}
