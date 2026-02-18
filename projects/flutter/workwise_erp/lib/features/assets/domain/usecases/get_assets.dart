import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/asset.dart';
import '../repositories/asset_repository.dart';

class GetAssets {
  final AssetRepository repository;
  GetAssets(this.repository);

  Future<Either<Failure, List<Asset>>> call() async {
    return repository.getAssets();
  }
}
