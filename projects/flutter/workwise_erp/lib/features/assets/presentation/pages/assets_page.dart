import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';
import '../providers/assets_providers.dart';
import '../state/assets_state.dart';
import '../widgets/asset_tile.dart';

class AssetsPage extends ConsumerStatefulWidget {
  const AssetsPage({super.key});

  @override
  ConsumerState<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends ConsumerState<AssetsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(assetsNotifierProvider.notifier).loadAssets();
    });
  }

  Future<void> _refresh() => ref.read(assetsNotifierProvider.notifier).loadAssets();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assetsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AssetsState>(assetsNotifierProvider, (prev, next) {
      final prevLoading = prev?.maybeWhen(loading: () => true, orElse: () => false) ?? false;
      final nextLoading = next.maybeWhen(loading: () => true, orElse: () => false);
      if (prevLoading == nextLoading) return;
      // keep UI minimal for assets (no global modal)
    });

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
            if (assets.isEmpty) {
              return Center(
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
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: assets.length,
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                itemBuilder: (context, idx) {
                  final a = assets[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AssetTile(
                      asset: a,
                      onTap: () {
                        Navigator.pushNamed(context, '/assets/detail', arguments: a.id);
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quick action placeholder — navigation to create asset can be added
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
