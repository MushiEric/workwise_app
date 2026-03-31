import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../../domain/entities/invoice.dart' as domain;
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_remote_data_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remote;
  InvoiceRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<domain.Invoice>>> getInvoices() async {
    try {
      final models = await remote.getInvoices();
      return Either.right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
