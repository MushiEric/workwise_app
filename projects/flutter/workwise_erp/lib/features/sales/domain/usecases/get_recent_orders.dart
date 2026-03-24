import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/sales_repository.dart';
import '../entities/sales_order.dart';

class GetRecentOrders {
  final SalesRepository repository;
  GetRecentOrders(this.repository);

  Future<Either<Failure, List<SalesOrder>>> call([Map<String, dynamic>? params]) async {
    return repository.getRecentOrders(params);
  }
}
