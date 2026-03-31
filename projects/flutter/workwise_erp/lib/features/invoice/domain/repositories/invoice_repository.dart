import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../entities/invoice.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, List<Invoice>>> getInvoices();
  Future<Either<Failure, Invoice>> getInvoiceById(String id);
  Future<Either<Failure, void>> saveInvoice(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateInvoice(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteInvoice(String id);
}
