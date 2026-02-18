import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/asset.dart';

part 'assets_state.freezed.dart';

@freezed
class AssetsState with _$AssetsState {
  const factory AssetsState.initial() = _Initial;
  const factory AssetsState.loading() = _Loading;
  const factory AssetsState.loaded(List<Asset> assets) = _Loaded;
  const factory AssetsState.error(String message) = _Error;
}
