import 'package:dio/dio.dart';
import 'package:workwise_erp/core/errors/exceptions.dart';

import '../models/geofence_model.dart';

class GeofenceRemoteDataSource {
  final Dio client;
  GeofenceRemoteDataSource(this.client);

  // TODO: Confirm exact endpoint paths with your backend team if these differ.
  // backend uses explicit "get" path rather than bare resource
  static const String _geofenceEndpoint = '/geofence/getGeofence';
  // actual path observed by backend
  static const String _assetGeofenceEndpoint = '/geofence/getAssetGeofence';

  /// GET /geofence/ — returns all geofence zones.
  Future<List<GeofenceModel>> getGeofences() async {
    try {
      // log the constructed URI for diagnostics
      final uri = '${client.options.baseUrl}$_geofenceEndpoint';
      // ignore: avoid_print
      print('[Geofence] fetching from $uri');
      final resp = await client.get('$_geofenceEndpoint');
      final list = _extractList(resp.data);
      return list
          .map((j) => GeofenceModel.fromJson(Map<String, dynamic>.from(j)))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GET /geofence/asset/{registrationNumber}
  /// Returns geofences for a specific vehicle including [isCurrentlyInside].
  Future<List<GeofenceModel>> getAssetGeofences(
      String registrationNumber) async {
    try {
      final full = '${client.options.baseUrl}$_assetGeofenceEndpoint/${Uri.encodeComponent(registrationNumber)}';
      // ignore: avoid_print
      print('[Geofence] fetching asset geofences from $full');
      final resp = await client
          .get('$_assetGeofenceEndpoint/${Uri.encodeComponent(registrationNumber)}');
      final list = _extractList(resp.data, forAsset: true);
      return list
          .map((j) => GeofenceModel.fromJson(Map<String, dynamic>.from(j)))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Handles both response shapes:
  ///   • `{"data": [...]}` — all geofences
  ///   • `{"data": {"geofences": [...], "asset": {...}}}` — asset geofences
  List<Map<String, dynamic>> _extractList(dynamic raw,
      {bool forAsset = false}) {
    List<dynamic> rawList = const [];

    if (raw is List) {
      rawList = raw;
    } else if (raw is Map) {
      final data = raw['data'];
      if (data is List) {
        rawList = data;
      } else if (data is Map) {
        final inner = data['geofences'];
        if (inner is List) rawList = inner;
      }
    }

    return rawList
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}
