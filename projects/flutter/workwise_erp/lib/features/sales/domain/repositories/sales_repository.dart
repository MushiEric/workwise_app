import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/sales_order.dart';

abstract class SalesRepository {
  /// Fetch recent sales orders (GET /order/getRecentOrders)
  Future<Either<Failure, List<SalesOrder>>> getRecentOrders();
}
