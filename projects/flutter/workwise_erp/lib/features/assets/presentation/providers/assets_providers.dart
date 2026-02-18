import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/provider/dio_provider.dart';
import '../../data/datasources/asset_remote_data_source.dart';
import '../../data/repositories/asset_repository_impl.dart';
import '../../domain/repositories/asset_repository.dart';
import '../../domain/usecases/get_assets.dart';
import '../notifier/assets_notifier.dart';
import '../state/assets_state.dart';

final assetRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return AssetRemoteDataSource(dio);
});

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
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
