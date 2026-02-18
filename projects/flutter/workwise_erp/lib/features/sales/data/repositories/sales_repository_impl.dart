import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../../domain/entities/sales_order.dart' as domain;
import '../../domain/repositories/sales_repository.dart';
import '../datasources/sales_remote_data_source.dart';
import '../models/order_model.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource remote;

  // basic in-memory cache to reduce churn
  List<OrderModel>? _cache;
  DateTime? _lastFetch;
  static const Duration _cacheTtl = Duration(seconds: 20);

  SalesRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<domain.SalesOrder>>> getRecentOrders() async {
    try {
      final now = DateTime.now();
      if (_cache != null &&
          _lastFetch != null &&
          now.difference(_lastFetch!) < _cacheTtl) {
        final list = _cache!.map((m) => m.toDomain()).toList();
        return Either.right(list);
      }

      final List<OrderModel> models = await remote.getRecentOrders();
      _cache = models;
      _lastFetch = DateTime.now();

      final list = models.map((m) => m.toDomain()).toList();
      return Either.right(list);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  /// Invalidate local cache (call after create/update/delete)
  void invalidateCache() {
    _cache = null;
    _lastFetch = null;
  }
}
