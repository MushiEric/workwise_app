import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../domain/entities/asset.dart';
import '../providers/assets_providers.dart';
import '../widgets/asset_tile.dart';

class AssetsPage extends ConsumerStatefulWidget {
  const AssetsPage({super.key});

  @override
  ConsumerState<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends ConsumerState<AssetsPage> {
  /// 'all' | 'gps' | 'moving'
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(assetsNotifierProvider.notifier).loadAssets();
    });
  }

  Future<void> _refresh() => ref.read(assetsNotifierProvider.notifier).loadAssets();

  List<Asset> _applyFilter(List<Asset> assets) {
    switch (_filter) {
      case 'gps':
        return assets.where((a) => (a.hasGps ?? false) && a.latitude != null).toList();
      case 'moving':
        return assets.where((a) => (a.speed ?? 0) > 0).toList();
      default:
        return assets;
    }
  }

  Widget _chip(String value, String label, int count, bool isDark) {
    final selected = _filter == value;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: selected,
      onSelected: (_) => setState(() => _filter = value),
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(
        color: selected ? AppColors.primary : (isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.grey.shade700),
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assetsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: 'Assets'),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: state.when(
          initial: () => const Center(child: SizedBox.shrink()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (msg) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 64, color: isDark ? Colors.red.shade300 : Colors.red.shade400),
                const SizedBox(height: 12),
                Text('Failed to load assets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2634))),
                const SizedBox(height: 8),
                Text(msg, textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600)),
                const SizedBox(height: 16),
                ElevatedButton.icon(onPressed: _refresh, icon: const Icon(Icons.refresh_rounded), label: const Text('Retry'))
              ],
            ),
          ),
          loaded: (assets) {
            final gpsCount = assets.where((a) => (a.hasGps ?? false) && a.latitude != null).length;
            final movingCount = assets.where((a) => (a.speed ?? 0) > 0).length;
            final filtered = _applyFilter(assets);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _chip('all', 'All', assets.length, isDark),
                    const SizedBox(width: 8),
                    _chip('gps', 'GPS Live', gpsCount, isDark),
                    const SizedBox(width: 8),
                    _chip('moving', 'Moving', movingCount, isDark),
                  ]),
                ),
                const SizedBox(height: 12),

                // List
                Expanded(
                  child: assets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 80, color: isDark ? Colors.white24 : Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text('No assets found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                              const SizedBox(height: 8),
                              Text('You can add assets from the web portal', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600)),
                            ],
                          ),
                        )
                      : filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off_rounded, size: 64, color: isDark ? Colors.white24 : Colors.grey.shade300),
                                  const SizedBox(height: 12),
                                  Text('No vehicles match this filter', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600)),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              child: ListView.builder(
                                itemCount: filtered.length,
                                padding: const EdgeInsets.only(top: 8, bottom: 16),
                                itemBuilder: (context, idx) {
                                  final a = filtered[idx];
                                  return AssetTile(
                                    asset: a,
                                    onTap: () => Navigator.pushNamed(context, '/assets/detail', arguments: a.id),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(LucideIcons.plus, size: 20),
      ),
    );
  }
}
