import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';


abstract class AssetRepository {
  Future<Either<Failure, List<Asset>>> getAssets();
}
