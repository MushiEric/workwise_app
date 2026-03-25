import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/sales_order.dart';

abstract class SalesRepository {
  /// Fetch recent sales orders (POST /order/getRecentOrders)
  Future<Either<Failure, List<SalesOrder>>> getRecentOrders([Map<String, dynamic>? params]);
}
