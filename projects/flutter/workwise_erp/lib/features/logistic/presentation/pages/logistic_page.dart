import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../assets/presentation/providers/assets_providers.dart';
import '../../../assets/presentation/widgets/asset_tile.dart';
import '../../../assets/domain/entities/asset.dart';
import '../providers/operators_providers.dart';
import '../providers/trips_providers.dart';
import '../providers/geofence_providers.dart';
import '../widgets/operator_tile.dart';
import '../widgets/trip_tile.dart';

class LogisticPage extends ConsumerStatefulWidget {
  const LogisticPage({super.key});

  @override
  ConsumerState<LogisticPage> createState() => _LogisticPageState();
}

class _LogisticPageState extends ConsumerState<LogisticPage> {
  int _currentIndex = 0;

  // search/filter UI state used only on the vehicle tab
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFilter; // 'active','idle','offline' (UI only)

  /// current vehicle category shown on the vehicle tab; 'truck','trailer','small'
  String _selectedVehicleCategory = 'truck';

  /// controller for the geofence map — used to auto-fit bounds after creation
  GoogleMapController? _geofenceMapController;

  static const List<String> _labels = ['Vehicle', 'Geofences', 'Journey', 'Trip', 'Operators', 'Workshop'];
  static const List<IconData> _icons = [Icons.car_rental, Icons.map, Icons.timeline, Icons.directions_car, Icons.person, Icons.build];

  /// Computes the tightest [LatLngBounds] that contains all [points].
  LatLngBounds _computeBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    // Prevent zero-size bounds (single point) which crash animateCamera
    if (minLat == maxLat && minLng == maxLng) {
      return LatLngBounds(
        southwest: LatLng(minLat - 0.01, minLng - 0.01),
        northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
      );
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Color? _colorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceAll('#', '').trim();
    try {
      final value = int.parse(cleaned, radix: 16);
      if (cleaned.length == 6) {
        return Color(0xFF000000 | value);
      } else if (cleaned.length == 8) {
        return Color(value);
      }
    } catch (_) {}
    return null;
  }

  List<LatLng> _parsePoints(String? coords) {
    if (coords == null) return [];
    try {
      final list = jsonDecode(coords) as List;
      return list
          .map((e) => LatLng((e['lat'] as num).toDouble(), (e['lng'] as num).toDouble()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    // prefetch assets & operators so tabs render quickly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        ref.read(assetsNotifierProvider.notifier).loadAssets();
      } catch (_) {}
      try {
        ref.read(geofenceNotifierProvider.notifier).loadGeofences();
      } catch (_) {}
      try {
        ref.read(operatorsNotifierProvider.notifier).loadOperators();
      } catch (_) {}
      try {
        ref.read(tripsNotifierProvider.notifier).loadTrips();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _geofenceMapController?.dispose();
    super.dispose();
  }

  Widget _buildVehicleTab(BuildContext context) {
    final state = ref.watch(assetsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // helper to perform search filtering on a list
    List<Asset> _applySearch(List<Asset> list) {
      final q = _searchController.text.trim().toLowerCase();
      if (q.isEmpty) return list;
      return list.where((a) {
        final name = a.name?.toLowerCase() ?? '';
        final reg = a.registrationNumber?.toLowerCase() ?? '';
        return name.contains(q) || reg.contains(q);
      }).toList();
    }

    List<Asset> _applySearchAndFilter(List<Asset> list) {
      var res = _applySearch(list);
      if (_selectedFilter != null) {
        switch (_selectedFilter) {
          case 'active':
            res = res.where((a) => a.isActive == true).toList();
            break;
          case 'idle':
            // placeholder condition; adjust when backend defines idle status
            res = res.where((a) => a.status?.toLowerCase() == 'idle').toList();
            break;
          case 'offline':
            res = res.where((a) => a.isAvailable == false).toList();
            break;
        }
      }
      return res;
    }

    // generic list display for a given asset subset
    Widget _vehicleList(List<Asset> list) {
      if (list.isEmpty) {
        return Center(
          child: Text('No vehicles found', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade700)),
        );
      }
      return RefreshIndicator(
        onRefresh: () => ref.read(assetsNotifierProvider.notifier).loadAssets(),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: list.length,
          itemBuilder: (context, idx) {
            final a = list[idx];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AssetTile(asset: a, onTap: () => Navigator.pushNamed(context, '/assets/detail', arguments: a.id)),
            );
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (msg) => Center(child: Text(msg)),
        loaded: (assets) {
          if (assets.isEmpty) {
            return Center(
              child: Text('No vehicles found', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade700)),
            );
          }

          // partition by type. backend currently sends numeric codes as strings
          // 1 -> truck, 2 -> trailer, 3 -> small vehicles. fall back to checking
          // for the word just in case (older data).
          final trucks = assets.where((a) {
            final t = a.type;
            if (t == '1') return true;
            final l = t?.toLowerCase() ?? '';
            return l.contains('truck');
          }).toList();
          final trailers = assets.where((a) {
            final t = a.type;
            if (t == '2') return true;
            final l = t?.toLowerCase() ?? '';
            return l.contains('trailer');
          }).toList();
          final smalls = assets.where((a) {
            final t = a.type;
            if (t == '3') return true;
            final l = t?.toLowerCase() ?? '';
            return l.contains('small');
          }).toList();

          final filteredTrucks = _applySearchAndFilter(trucks);
          final filteredTrailers = _applySearchAndFilter(trailers);
          final filteredSmalls = _applySearchAndFilter(smalls);

          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // optional total count header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('Vehicles: ${assets.length}', style: Theme.of(context).textTheme.bodyMedium),
                ),
              // category selection row (clickable containers)
              Row(
                children: [
                  _categoryTile(context, 'truck', 'Trucks', filteredTrucks.length),
                  _categoryTile(context, 'trailer', 'Trailers', filteredTrailers.length),
                  _categoryTile(context, 'small', 'Small vehicles', filteredSmalls.length),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: () {
                  switch (_selectedVehicleCategory) {
                    case 'trailer':
                      return _vehicleList(filteredTrailers);
                    case 'small':
                      return _vehicleList(filteredSmalls);
                    case 'truck':
                    default:
                      return _vehicleList(filteredTrucks);
                  }
                }(),
              ),
            ],
            )
          );
        },
      ),
    );
  }

  Widget _buildGeofenceTab(BuildContext context) {
    final state = ref.watch(geofenceNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (msg) => Center(child: Text(msg, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade700))),
        loaded: (geofences) {
          if (geofences.isEmpty) {
            return Center(child: Text('No geofences found', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade700)));
          }

          // ── collect all geofence shapes ─────────────────────────────
          final Set<Polygon> polygons = {};
          final Set<Circle> circles = {};
          final List<LatLng> allPoints = []; // used to auto-fit bounds

          for (var g in geofences) {
            if (g.type == 'polygon') {
              final pts = _parsePoints(g.coordinates);
              if (pts.isNotEmpty) {
                polygons.add(Polygon(
                    polygonId: PolygonId(g.id.toString()),
                    points: pts,
                    strokeWidth: 2,
                    strokeColor: _colorFromHex(g.color) ?? Colors.blue,
                    fillColor: (_colorFromHex(g.color) ?? Colors.blue).withOpacity(0.2)));
                allPoints.addAll(pts);
              }
            } else if (g.type == 'circle') {
              final lat = g.centerLat != null ? double.tryParse(g.centerLat!) : g.latitude;
              final lng = g.centerLng != null ? double.tryParse(g.centerLng!) : g.longitude;
              final rad = g.radius != null ? double.tryParse(g.radius!) : null;
              if (lat != null && lng != null && rad != null) {
                circles.add(Circle(
                    circleId: CircleId(g.id.toString()),
                    center: LatLng(lat, lng),
                    radius: rad,
                    strokeWidth: 2,
                    strokeColor: _colorFromHex(g.color) ?? Colors.blue,
                    fillColor: (_colorFromHex(g.color) ?? Colors.blue).withOpacity(0.2)));
                // Approximate circle extent for bounds
                final degOffset = rad / 111000;
                allPoints.add(LatLng(lat + degOffset, lng + degOffset));
                allPoints.add(LatLng(lat - degOffset, lng - degOffset));
              }
            }
          }

          // Fallback centre when no shapes parsed
          final LatLng fallbackCenter =
              allPoints.isNotEmpty ? allPoints.first : const LatLng(0, 0);

          return Column(
            children: [
              // ── Map takes up 55 % of available height ─────────────────
              Expanded(
                flex: 55,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: fallbackCenter,
                      zoom: 6,
                    ),
                    polygons: polygons,
                    circles: circles,
                    zoomControlsEnabled: true,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: (controller) {
                      _geofenceMapController = controller;
                      if (allPoints.isNotEmpty) {
                        final bounds = _computeBounds(allPoints);
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) {
                            controller.animateCamera(
                              CameraUpdate.newLatLngBounds(bounds, 60),
                            );
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // ── List takes up the remaining 45 % ──────────────────────
              Expanded(
                flex: 45,
                child: RefreshIndicator(
                  onRefresh: () => ref.read(geofenceNotifierProvider.notifier).loadGeofences(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: geofences.length,
                    itemBuilder: (context, idx) {
                      final g = geofences[idx];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              _colorFromHex(g.color) ?? Colors.blueAccent,
                        ),
                        title: Text(g.name ?? 'Unnamed zone'),
                        subtitle: Text(
                          g.type?.toUpperCase() ?? '',
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: g.isCurrentlyInside
                            ? const Icon(Icons.check_circle,
                                color: Colors.green, size: 18)
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOperatorsTab(BuildContext context) {
    final state = ref.watch(operatorsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (msg) => Center(child: Text(msg)),
        loaded: (operators) {
          if (operators.isEmpty) return Center(child: Text('No operators found', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade700)));
          return RefreshIndicator(
            onRefresh: () => ref.read(operatorsNotifierProvider.notifier).loadOperators(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: operators.length,
              itemBuilder: (context, idx) {
                final o = operators[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OperatorTile(operatorModel: o, onTap: () => Navigator.pushNamed(context, '/logistic/operators/detail', arguments: o.id)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripTab(BuildContext context) {
    final state = ref.watch(tripsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (msg) => Center(child: Text(msg, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade700))),
        loaded: (trips) {
          if (trips.isEmpty) {
            return Center(child: Text('No trips found', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade700)));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(tripsNotifierProvider.notifier).loadTrips(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: trips.length,
              itemBuilder: (context, idx) {
                final t = trips[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TripTile(
                    trip: t,
                    onTap: () => Navigator.pushNamed(context, '/logistic/trips'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _placeholder(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(text, style: TextStyle(fontSize: 16, color: isDark ? Colors.white54 : Colors.grey.shade700)),
      ),
    );
  }

  /// clickable category card used instead of tabs
  Widget _categoryTile(BuildContext context, String key, String label, int count) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = _selectedVehicleCategory == key;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedVehicleCategory = key;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppColors.primary : (isDark ? Colors.white10 : Colors.grey.shade300),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: selected ? AppColors.primary : (isDark ? Colors.white : Colors.black))),
              const SizedBox(height: 4),
              Text('$count', style: TextStyle(fontSize: 12, color: selected ? AppColors.primary : (isDark ? Colors.white54 : Colors.grey.shade600))),
            ],
          ),
        ),
      ),
    );
  }

  /// Animated search bar shown when [_isSearching] is true.
  Widget _buildSearchBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search vehicles...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
              prefixIcon: Icon(
                LucideIcons.search,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  LucideIcons.x,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _isSearching = false;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A2634)),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Active vehicles'),
              trailing: _selectedFilter == 'active' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _selectedFilter = 'active');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Idle'),
              trailing: _selectedFilter == 'idle' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _selectedFilter = 'idle');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Offline'),
              trailing: _selectedFilter == 'offline' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _selectedFilter = 'offline');
                Navigator.pop(ctx);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Clear filters'),
              onTap: () {
                setState(() => _selectedFilter = null);
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    final tabs = <Widget>[
      _buildVehicleTab(context),
      _buildGeofenceTab(context),
      _placeholder('Journey - placeholder'),
      _buildTripTab(context),
      _buildOperatorsTab(context),
      _placeholder('Workshop - placeholder'),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Logistic',
        actions: [
          if (_currentIndex == 0) ...[
            IconButton(
              icon: Icon(_isSearching ? LucideIcons.x : LucideIcons.search, size: 20),
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _searchController.clear();
                  }
                  _isSearching = !_isSearching;
                });
              },
            ),
            IconButton(
              icon: const Icon(LucideIcons.filter, size: 20),
              onPressed: () => _showFilterSheet(context),
            ),
          ],
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          if (_currentIndex == 0 && _isSearching) _buildSearchBar(context),
          Expanded(
            child: _currentIndex == 0
                ? DefaultTabController(length: 3, child: tabs[0])
                : tabs[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: List.generate(_labels.length, (i) => BottomNavigationBarItem(icon: Icon(_icons[i]), label: _labels[i])),
      ),
    );
  }
}
