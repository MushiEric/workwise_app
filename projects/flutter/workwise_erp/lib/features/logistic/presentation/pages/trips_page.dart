import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_modal.dart';
import '../../domain/entities/trip.dart';
import '../providers/trips_providers.dart';
import '../widgets/trip_tile.dart';

class TripsPage extends ConsumerStatefulWidget {
  const TripsPage({super.key});

  @override
  ConsumerState<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends ConsumerState<TripsPage> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _selectedStatus; // null = All

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripsNotifierProvider.notifier).loadTrips();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _refresh() => ref.read(tripsNotifierProvider.notifier).loadTrips();

  List<Trip> _filter(List<Trip> all) {
    var list = all;
    if (_selectedStatus != null) {
      list = list.where((t) => t.statusName == _selectedStatus).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((t) {
        return (t.tripNumber?.toLowerCase().contains(q) ?? false) ||
            (t.customerName?.toLowerCase().contains(q) ?? false) ||
            (t.routeName?.toLowerCase().contains(q) ?? false) ||
            (t.operatorName?.toLowerCase().contains(q) ?? false) ||
            (t.vehicleNumber?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    return list;
  }

  /// Unique status list from the loaded trips
  List<String> _statuses(List<Trip> all) {
    final seen = <String>{};
    return all.map((t) => t.statusName).whereType<String>().where(seen.add).toList();
  }

  void _showTripDetail(Trip trip) {
    AppModal.show(
      context: context,
      title: 'Trip ${trip.tripNumber ?? ''}',
      subtitle: trip.routeName != null && trip.routeName != 'N/A' ? trip.routeName : null,
      icon: Icons.directions_car_rounded,
      iconColor: hexToColor(trip.statusColor, fallback: AppColors.primary),
      content: _TripDetailContent(trip: trip),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Trips',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _refresh,
          ),
        ],
      ),
      body: state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (msg) => _ErrorView(message: msg, onRetry: _refresh),
        loaded: (trips) {
          final filtered = _filter(trips);
          final statuses = _statuses(trips);

          return Column(
            children: [
              // ── Search bar ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    hintText: 'Search trip, customer, route…',
                    hintStyle: TextStyle(fontSize: 14, color: isDark ? Colors.white38 : Colors.grey.shade400),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.05) : AppColors.surfaceVariantLight,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                ),
              ),

              // ── Status filter chips ───────────────────────────────────
              if (statuses.isNotEmpty)
                SizedBox(
                  height: 44,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _StatusChip(
                        label: 'All',
                        selected: _selectedStatus == null,
                        color: AppColors.primary,
                        onTap: () => setState(() => _selectedStatus = null),
                      ),
                      ...statuses.map((s) {
                        final color = hexToColor(
                          trips.firstWhere((t) => t.statusName == s).statusColor,
                          fallback: AppColors.muted,
                        );
                        return _StatusChip(
                          label: s,
                          selected: _selectedStatus == s,
                          color: color,
                          onTap: () => setState(() => _selectedStatus = s),
                        );
                      }),
                    ],
                  ),
                ),

              // ── Summary count ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${filtered.length} trip${filtered.length == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Trip list ─────────────────────────────────────────────
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyView(
                        hasFilters: _searchQuery.isNotEmpty || _selectedStatus != null,
                        onClear: () => setState(() {
                          _searchQuery = '';
                          _searchCtrl.clear();
                          _selectedStatus = null;
                        }),
                      )
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                          itemCount: filtered.length,
                          itemBuilder: (context, idx) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TripTile(
                              trip: filtered[idx],
                              onTap: () => _showTripDetail(filtered[idx]),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Status filter chip ──────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? color : color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : color.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error view ──────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: isDark ? Colors.red.shade300 : Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load trips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty view ──────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClear;

  const _EmptyView({required this.hasFilters, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off_rounded : Icons.local_shipping_outlined,
            size: 72,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters ? 'No trips match your filters' : 'No trips found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          if (hasFilters)
            TextButton(
              onPressed: onClear,
              child: const Text('Clear filters'),
            ),
        ],
      ),
    );
  }
}

// ── Trip detail modal content ───────────────────────────────────────────────

class _TripDetailContent extends StatelessWidget {
  final Trip trip;

  const _TripDetailContent({required this.trip});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = hexToColor(trip.statusColor, fallback: AppColors.muted);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status badge
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(
                  trip.statusName ?? 'Unknown',
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        _DetailSection(
          title: 'Trip Info',
          isDark: isDark,
          children: [
            _DetailRow(label: 'Trip Number', value: trip.tripNumber),
            _DetailRow(label: 'Route', value: trip.routeName),
            _DetailRow(label: 'ETD', value: trip.etd),
            _DetailRow(label: 'ETA', value: trip.etas),
          ],
        ),
        const SizedBox(height: 16),

        _DetailSection(
          title: 'Parties',
          isDark: isDark,
          children: [
            _DetailRow(label: 'Customer', value: trip.customerName),
            _DetailRow(label: 'Operator', value: trip.operatorName),
            _DetailRow(label: 'Vehicle', value: trip.vehicleNumber),
          ],
        ),
        const SizedBox(height: 16),

        _DetailSection(
          title: 'Cargo & Finance',
          isDark: isDark,
          children: [
            _DetailRow(label: 'Cargo Capacity', value: trip.cargoCapacity),
            _DetailRow(label: 'Opening Balance', value: trip.openingBalance),
          ],
        ),
        const SizedBox(height: 16),

        _DetailSection(
          title: 'Timestamps',
          isDark: isDark,
          children: [
            _DetailRow(label: 'Created', value: trip.createdAt),
            _DetailRow(label: 'Updated', value: trip.updatedAt),
          ],
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isDark;

  const _DetailSection({required this.title, required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final nonNull = children.whereType<_DetailRow>().where((r) => r.value != null && r.value!.isNotEmpty && r.value != 'N/A').toList();
    if (nonNull.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.04) : AppColors.surfaceVariantLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: nonNull),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;

  const _DetailRow({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty || value == 'N/A') return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF1A2634),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
