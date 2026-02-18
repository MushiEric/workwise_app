import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_bar.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';
import '../../../../core/themes/app_colors.dart';
import '../providers/assets_providers.dart';
import '../../domain/entities/asset.dart' as domain;

class AssetDetailPage extends ConsumerStatefulWidget {
  const AssetDetailPage({super.key});

  @override
  ConsumerState<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends ConsumerState<AssetDetailPage> {
  int? _idFromArgs;
  domain.Asset? _assetFromArgs;

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
        appBar: CustomAppBar(title: 'Vehicle Detail'),
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
      appBar: CustomAppBar(title: 'Vehicle Detail'),
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
              _infoRow('Has GPS', (a.hasGps ?? false) ? 'Yes' : 'No'),
              _infoRow('Status', a.status, emphasize: true),
              _infoRow('Created At', a.createdAt),
            ]),
          ),

          const SizedBox(height: 16),

          // Attachments placeholder
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [Icon(Icons.attachment_outlined, color: AppColors.primary), const SizedBox(width: 8), Text('Attachments', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1A2634))),]),
              ),
              const Divider(height: 1),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(isDark ? Colors.white10 : Colors.grey.shade100),
                  columns: const [
                    DataColumn(label: Text('S/N')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('File')),
                  ],
                  rows: const [],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
