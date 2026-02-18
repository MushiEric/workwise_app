import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../../domain/entities/asset.dart' as domain;
import '../../domain/repositories/asset_repository.dart';
import '../datasources/asset_remote_data_source.dart';
import '../models/asset_model.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDataSource remote;
  AssetRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<domain.Asset>>> getAssets() async {
    try {
      final models = await remote.getAssets();
      return Either.right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
