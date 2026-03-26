import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';
import '../../../../core/themes/app_colors.dart';
import '../providers/assets_providers.dart';
import '../../domain/entities/asset_links.dart' as domain;

class AssetDetailPage extends ConsumerStatefulWidget {
  const AssetDetailPage({super.key});

  @override
  ConsumerState<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends ConsumerState<AssetDetailPage> {
  int? _idFromArgs;
  domain.Asset? _assetFromArgs;
  GoogleMapController? _gpsMapController;
  BitmapDescriptor? _truckMarkerIcon;
  Color? _lastMarkerColor;

  @override
  void dispose() {
    _gpsMapController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is int) {
      _idFromArgs = arg;
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(assetsNotifierProvider.notifier).loadAssets());
    } else if (arg is domain.Asset) {
      _assetFromArgs = arg;
    }
  }

  Widget _infoRow(String label, String? value, {bool emphasize = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelWidth = MediaQuery.of(context).size.width >= 600 ? 160.0 : 120.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: labelWidth, child: Text(label, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value ?? '-', style: TextStyle(fontWeight: emphasize ? FontWeight.w600 : FontWeight.w400, color: isDark ? Colors.white : const Color(0xFF1A2634))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assetsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve asset to display (argument preferred, then lookup by id)
    domain.Asset? asset = _assetFromArgs;
    if (asset == null && _idFromArgs != null) {
      state.maybeWhen(loaded: (list) {
        try {
          asset = list.firstWhere((x) => x.id == _idFromArgs);
        } catch (_) {
          asset = null;
        }
      }, orElse: () {});
    }

    final loading = state.maybeWhen(loading: () => true, orElse: () => false) && asset == null;

    if (loading) {
      return Scaffold(appBar: CustomAppBar(title: 'Vehicle Detail'), drawer: const AppDrawer(), body: const Center(child: CircularProgressIndicator()));
    }

    if (asset == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Vehicle Deta'),
        drawer: const AppDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 64, color: isDark ? Colors.red.shade300 : Colors.red.shade400),
                const SizedBox(height: 12),
                Text('Vehicle not found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2634))),
                const SizedBox(height: 8),
                Text('The requested vehicle could not be loaded. Try refreshing the assets list.', textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600)),
                const SizedBox(height: 16),
                ElevatedButton.icon(onPressed: () => ref.read(assetsNotifierProvider.notifier).loadAssets(), icon: const Icon(Icons.refresh_rounded), label: const Text('Reload'))
              ],
            ),
          ),
        ),
      );
    }

    final domain.Asset a = asset!;

    Color statusColor = AppColors.primary;
    final statusLabel = a.status ?? '';
    if (statusLabel == '3' || statusLabel.toLowerCase().contains('unavailable') || statusLabel.toLowerCase().contains('broken')) {
      statusColor = Colors.orange;
    } else if (statusLabel == '5' || statusLabel.toLowerCase().contains('inactive') || statusLabel.toLowerCase().contains('decommission')) {
      statusColor = Colors.grey;
    } else if (statusLabel == '1' || statusLabel.toLowerCase().contains('available') || statusLabel.toLowerCase().contains('active')) {
      statusColor = Colors.green;
    }

    return Scaffold(
      appBar: CustomAppBar(title: a.name  ?? 'Vehicle Detail'),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
            ),
            child: Row(children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primary.withOpacity(0.06)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Builder(builder: (context) {
                    final prov = imageProviderFromUrl(a.image);
                    if (prov != null) {
                      return Image(image: prov, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.local_shipping_outlined));
                    }
                    return const Icon(Icons.local_shipping_outlined, size: 44);
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.name ?? 'Unnamed vehicle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2634))),
                  const SizedBox(height: 6),
                  if (a.registrationNumber != null && a.registrationNumber!.isNotEmpty) Text(a.registrationNumber!, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700)),
                  if ((a.model ?? '').isNotEmpty) Text('${a.model ?? ''} ${a.year ?? ''}'.trim(), style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(statusLabel.isEmpty ? 'Unknown' : statusLabel, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
                ]),
              ),
            ]),
          ),

          const SizedBox(height: 16),

          // GPS tracking section
          _buildGpsSection(a, isDark),

          // Linked units section
          _buildLinkedUnitsSection(a, isDark),

          // Details card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _infoRow('Asset ID', a.assetId),
              _infoRow('Type', a.type),
              _infoRow('Registration', a.registrationNumber),
              _infoRow('Model', a.model),
              _infoRow('Year', a.year),
              _infoRow('VIN', a.vin),
              _infoRow('Make', a.make),
              _infoRow('Company', a.company),
              _infoRow('Fuel consumption', a.fuelConsumption?.toString()),
              _infoRow('Status', a.status, emphasize: true),
              _infoRow('Created At', a.createdAt),
            ]),
          ),

          const SizedBox(height: 16),

          // Attachments placeholder (temporarily hidden)
          // Container(
          //   decoration: BoxDecoration(
          //     color: isDark ? const Color(0xFF151A2E) : Colors.white,
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
          //   ),
          //   child: Column(children: [
          //     Padding(
          //       padding: const EdgeInsets.all(12),
          //       child: Row(children: [Icon(Icons.attachment_outlined, color: AppColors.primary), const SizedBox(width: 8), Text('Attachments', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1A2634))),]),
          //     ),
          //     const Divider(height: 1),
          //     SingleChildScrollView(
          //       scrollDirection: Axis.horizontal,
          //       child: DataTable(
          //         headingRowColor: MaterialStateProperty.all(isDark ? Colors.white10 : Colors.grey.shade100),
          //         columns: const [
          //           DataColumn(label: Text('S/N')),
          //           DataColumn(label: Text('Name')),
          //           DataColumn(label: Text('File')),
          //         ],
          //         rows: const [],
          //       ),
          //     ),
          //   ]),
          // ),
        ]),
      ),
    );
  }

  // ── GPS section ────────────────────────────────────────────────────

  Widget _buildGpsSection(domain.Asset a, bool isDark) {
    if (a.hasGps != true) return const SizedBox.shrink();

    final hasCoords = a.latitude != null && a.longitude != null;

    // Determine marker colour based on movement state
    final Color markerColor;
    if ((a.speed ?? 0) > 0 && a.ignition == true) {
      markerColor = Colors.green.shade600;
    } else if (a.ignition == true) {
      markerColor = Colors.orange.shade600;
    } else if (a.gpsValid == false) {
      markerColor = Colors.grey.shade500;
    } else {
      markerColor = Colors.blueGrey.shade600;
    }

    // Load / reload marker icon whenever the colour changes
    if (_lastMarkerColor != markerColor) {
      _lastMarkerColor = markerColor;
      _loadTruckMarkerIcon(markerColor);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(children: [
              Icon(Icons.gps_fixed_rounded, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text('GPS Tracking',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: isDark ? Colors.white : const Color(0xFF1A2634))),
              const Spacer(),
              if (a.gpsType != null) ...[
                Icon(Icons.sensors_rounded, size: 13, color: isDark ? Colors.white38 : Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(a.gpsType!, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey.shade500)),
              ],
              if (a.gpsValid == false) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text('Poor Signal',
                      style: TextStyle(fontSize: 11, color: Colors.orange.shade700, fontWeight: FontWeight.w500)),
                ),
              ],
            ]),
          ),

          if (hasCoords) ...[
            // Map
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              child: SizedBox(
                height: 320,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(a.latitude!, a.longitude!),
                    zoom: 14.5,
                  ),
                  onMapCreated: (c) => _gpsMapController = c,
                  markers: {
                    Marker(
                      markerId: const MarkerId('vehicle'),
                      position: LatLng(a.latitude!, a.longitude!),
                      rotation: a.heading ?? 0,
                      anchor: const Offset(0.5, 0.5),
                      icon: _truckMarkerIcon ?? BitmapDescriptor.defaultMarker,
                      infoWindow: InfoWindow(
                        title: a.name ?? 'Vehicle',
                        snippet: a.address,
                      ),
                    ),
                  },
                  polylines: (a.routeHistory != null && a.routeHistory!.length > 1)
                      ? {
                          Polyline(
                            polylineId: const PolylineId('route'),
                            points: a.routeHistory!.map((p) => LatLng(p[0], p[1])).toList(),
                            color: AppColors.primary,
                            width: 4,
                            patterns: [PatternItem.dash(20), PatternItem.gap(8)],
                          ),
                        }
                      : {},
                  scrollGesturesEnabled: false,
                  zoomControlsEnabled: true,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                ),
                ),
                ),
                const Divider(height: 1),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(isDark ? Colors.white10 : Colors.grey.shade100),
                  columns: const [
                    DataColumn(label: Text('S/N')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('File')),
                  ],
                  rows: const [],
                ),
              ),
          ] else ...[
            // Registered but not transmitting
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                ),
                child: Row(children: [
                  Icon(Icons.gps_not_fixed_rounded, color: Colors.orange.shade400, size: 34),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('GPS Not Transmitting',
                          style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1A2634))),
                      const SizedBox(height: 4),
                      Text(
                        'Device registered${a.gpsType != null ? ' via ${a.gpsType}' : ''}. '
                        'Awaiting first signal.',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600),
                      ),
                    ]),
                  ),
                ]),
              ),
            ),
            // Stats row
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Speed + ignition chips
                  Row(children: [
                    _gpsChip(
                      icon: (a.speed ?? 0) > 0 ? Icons.directions_car_rounded : Icons.local_parking_rounded,
                      label: a.speed != null ? '${a.speed!.toStringAsFixed(0)} km/h' : '— km/h',
                      color: (a.speed ?? 0) > 0 ? Colors.green : Colors.blueGrey,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _gpsChip(
                      icon: Icons.key_rounded,
                      label: a.ignition == null ? 'Unknown' : (a.ignition! ? 'Ignition ON' : 'Ignition OFF'),
                      color: a.ignition == true ? Colors.green : Colors.red,
                      isDark: isDark,
                    ),
                  ]),
                  const SizedBox(height: 10),

                  // Address
                  if (a.address != null)
                    Row(children: [
                      Icon(Icons.location_on_outlined, size: 13, color: isDark ? Colors.white38 : Colors.grey.shade500),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(a.address!,
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),

                  const SizedBox(height: 8),

                  // Last transmit · battery · satellites
                  Row(children: [
                    Icon(Icons.access_time_rounded, size: 13, color: isDark ? Colors.white38 : Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(_formatLastTransmit(a.lastTransmit),
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600)),
                    const Spacer(),
                    Icon(Icons.battery_charging_full_rounded,
                        size: 13, color: isDark ? Colors.white38 : Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(a.battery != null ? '${a.battery!.toStringAsFixed(1)}V' : '-',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600)),
                    const SizedBox(width: 14),
                    Icon(Icons.satellite_alt_rounded,
                        size: 13, color: isDark ? Colors.white38 : Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(a.satellites != null ? '${a.satellites} sat' : '-',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600)),
                  ]),
                ],
              ),
            ),          ],
        ],
      ),
    );
  }

  Widget _gpsChip({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
                overflow: TextOverflow.ellipsis),
          ),
        ]),
      ),
    );
  }

  String _formatLastTransmit(String? raw) {
    if (raw == null) return 'Never';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return raw;
    }
  }

  // ── Custom truck map marker ───────────────────────────────────────

  Future<void> _loadTruckMarkerIcon(Color color) async {
    final icon = await _buildTruckBitmap(color);
    if (mounted) setState(() => _truckMarkerIcon = icon);
  }

  /// Renders a coloured circle containing a truck icon into a [BitmapDescriptor]
  /// suitable for use as a Google Maps marker.
  static Future<BitmapDescriptor> _buildTruckBitmap(Color color) async {
    const double size = 120;
    const double iconSize = 58;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Shadow
    canvas.drawCircle(
      const Offset(size / 2, size / 2 + 4),
      size / 2 - 2,
      Paint()
        ..color = Colors.black.withOpacity(0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Filled circle
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 4,
      Paint()..color = color,
    );

    // White border ring
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 4,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    // Truck icon (Material icon font)
    final tp = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(Icons.local_shipping_rounded.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: Icons.local_shipping_rounded.fontFamily,
          package: Icons.local_shipping_rounded.fontPackage,
          color: Colors.white,
        ),
      )
      ..layout();
    tp.paint(
      canvas,
      Offset((size - tp.width) / 2, (size - tp.height) / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  // ── Linked Units section ─────────────────────────────────────────

  Widget _buildLinkedUnitsSection(domain.Asset a, bool isDark) {
    final hasDriver = a.linkedDriver != null;
    final hasTrailer = a.linkedTrailer != null;
    final hasTrips = a.recentTrips != null && a.recentTrips!.isNotEmpty;

    if (!hasDriver && !hasTrailer && !hasTrips) return const SizedBox.shrink();

    final cardBg = isDark ? const Color(0xFF151A2E) : Colors.white;
    final border = Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Linked Units card ───────────────────────────────────────
        if (hasDriver || hasTrailer)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: border,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Text(
                    'Linked Units',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                ),
                if (hasDriver) _linkedRow(
                  isDark: isDark,
                  leading: _initialsAvatar(a.linkedDriver!.name, isDark),
                  label: 'Driver',
                  title: a.linkedDriver!.name,
                  subtitle: a.linkedDriver!.phone,
                  isOnline: a.linkedDriver!.isOnDuty,
                  bottomBorder: hasTrailer,
                ),
                if (hasTrailer) _linkedRow(
                  isDark: isDark,
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.local_shipping_outlined,
                        color: AppColors.primary, size: 22),
                  ),
                  label: 'Trailer',
                  title: a.linkedTrailer!.registrationNumber,
                  subtitle: a.linkedTrailer!.name,
                  isOnline: null,
                  bottomBorder: false,
                ),
              ],
            ),
          ),

        // ── Recent Trips card ───────────────────────────────────────
        if (hasTrips)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: border,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Row(children: [
                    Text(
                      'Recent Trips',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${a.recentTrips!.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ]),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ...a.recentTrips!.asMap().entries.map((e) {
                  final trip = e.value;
                  final isLast = e.key == a.recentTrips!.length - 1;
                  return _tripRow(trip, isDark, isLast);
                }),
              ],
            ),
          ),
      ],
    );
  }

  Widget _linkedRow({
    required bool isDark,
    required Widget leading,
    required String label,
    required String title,
    String? subtitle,
    required bool? isOnline,
    required bool bottomBorder,
  }) {
    return Container(
      decoration: bottomBorder
          ? BoxDecoration(border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade100)))
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty) ...[  
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
              ],
            ]),
          ),
          if (isOnline != null) ...[  
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
          ],
          Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: isDark ? Colors.white24 : Colors.grey.shade400),
        ]),
      ),
    );
  }

  Widget _tripRow(domain.LinkedTrip trip, bool isDark, bool isLast) {
    Color statusColor = Colors.orange;
    if (trip.statusColor != null) {
      try {
        final hex = trip.statusColor!.replaceAll('#', '');
        statusColor = Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}
    }

    return Container(
      decoration: !isLast
          ? BoxDecoration(border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade100)))
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.route_rounded, color: statusColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              trip.tripNumber,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              trip.route ?? 'N/A',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              trip.statusName ?? '-',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
          if (trip.etd != null) ...[  
            const SizedBox(height: 4),
            Text(
              trip.etd!.split(' ').first,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white38 : Colors.grey.shade500,
              ),
            ),
          ],
        ]),
      ]),
    );
  }

  Widget _initialsAvatar(String name, bool isDark) {
    final parts = name.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts.first[0]}${parts[1][0]}'.toUpperCase()
        : name.isNotEmpty
            ? name[0].toUpperCase()
            : '?';
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}