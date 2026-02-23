import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../assets/presentation/providers/assets_providers.dart';
import '../../../assets/presentation/widgets/asset_tile.dart';
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

  static const List<String> _labels = ['Vehicle', 'Geofences', 'Journey', 'Trip', 'Operators', 'Workshop'];
  static const List<IconData> _icons = [Icons.car_rental, Icons.map, Icons.timeline, Icons.directions_car, Icons.person, Icons.build];

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

  Widget _buildVehicleTab(BuildContext context) {
    final state = ref.watch(assetsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (msg) => Center(child: Text(msg)),
        loaded: (assets) {
          if (assets.isEmpty) return Center(child: Text('No vehicles found', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade700)));
          return RefreshIndicator(
            onRefresh: () => ref.read(assetsNotifierProvider.notifier).loadAssets(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: assets.length,
              itemBuilder: (context, idx) {
                final a = assets[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AssetTile(asset: a, onTap: () => Navigator.pushNamed(context, '/assets/detail', arguments: a.id)),
                );
              },
            ),
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
          return RefreshIndicator(
            onRefresh: () => ref.read(geofenceNotifierProvider.notifier).loadGeofences(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: geofences.length,
              itemBuilder: (context, idx) {
                final g = geofences[idx];
                return ListTile(
                  title: Text(g.name ?? 'Unnamed zone'),
                  subtitle: Text(g.type ?? ''),
                  trailing: g.isCurrentlyInside ? Icon(Icons.check_circle, color: Colors.green) : null,
                );
              },
            ),
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
      appBar: CustomAppBar(title: 'Logistic'),
      drawer: const AppDrawer(),
      body: tabs[_currentIndex],
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
