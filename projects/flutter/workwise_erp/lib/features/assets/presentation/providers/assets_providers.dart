import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../../data/datasources/asset_remote_data_source.dart';
import '../../data/datasources/asset_mock_data_source.dart';
import '../../data/repositories/asset_repository_impl.dart';
import '../../domain/entities/asset.dart';
import '../../domain/repositories/asset_repository.dart';
import '../../domain/usecases/get_assets.dart';
import '../notifier/assets_notifier.dart';
import '../state/assets_state.dart';

/// Set to `true` to load mock GPS data during development.
/// Flip to `false` once the backend returns real GPS positions.
const bool kUseMockGps = true;

/// In-memory mock repository — returns [AssetMockDataSource.getAssets()]
/// with a small artificial delay to simulate a network call.
class _MockAssetRepository implements AssetRepository {
  @override
  Future<Either<Failure, List<Asset>>> getAssets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Either.right(AssetMockDataSource.getAssets());
  }
}

final assetRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return AssetRemoteDataSource(dio);
});

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  if (kUseMockGps) return _MockAssetRepository();
  final remote = ref.watch(assetRemoteDataSourceProvider);
  return AssetRepositoryImpl(remote);
});

final getAssetsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(assetRepositoryProvider);
  return GetAssets(repo);
});

final assetsNotifierProvider = StateNotifierProvider<AssetsNotifier, AssetsState>((ref) {
  final getAssets = ref.watch(getAssetsUseCaseProvider);
  return AssetsNotifier(getAssets: getAssets);
});
