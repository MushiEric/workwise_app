import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../../domain/repositories/asset_repository.dart';
import '../datasources/asset_remote_data_source.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDataSource remote;
  AssetRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<domain.Asset>>> getAssets() async {
    try {
      final assets = await remote.getAssets();
      return Either.right(assets);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
