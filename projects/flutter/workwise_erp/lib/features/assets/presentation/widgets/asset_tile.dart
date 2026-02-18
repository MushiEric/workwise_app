import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/asset.dart';
import '../../../../core/themes/app_colors.dart';

class AssetTile extends StatelessWidget {
  final Asset asset;
  final VoidCallback? onTap;

  const AssetTile({super.key, required this.asset, this.onTap});

  String _subtitle() {
    final parts = <String>[];
    if (asset.registrationNumber != null && asset.registrationNumber!.isNotEmpty) parts.add(asset.registrationNumber!);
    if (asset.model != null && asset.model!.isNotEmpty) parts.add(asset.model!);
    if (asset.year != null && asset.year!.isNotEmpty) parts.add(asset.year!);
    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary;

    final title = asset.name ?? 'Unnamed asset';
    final subtitle = _subtitle();

    Color statusColor = primary;
    String statusLabel = asset.status ?? '';
    if (statusLabel == '3' || statusLabel.toLowerCase().contains('unavailable') || statusLabel.toLowerCase().contains('broken')) {
      statusColor = Colors.orange;
    } else if (statusLabel == '5' || statusLabel.toLowerCase().contains('inactive') || statusLabel.toLowerCase().contains('decommission')) {
      statusColor = Colors.grey;
    } else if (statusLabel == '1' || statusLabel.toLowerCase().contains('available') || statusLabel.toLowerCase().contains('active')) {
      statusColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: primary.withOpacity(0.08),
                    border: Border.all(color: primary.withOpacity(0.12)),
                  ),
                  child: asset.image != null && asset.image!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(asset.image!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.directions_car_rounded)),
                        )
                      : Icon(Icons.local_shipping_outlined, color: primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1A2634)), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      if (subtitle.isNotEmpty)
                        Text(subtitle, style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text(
                            statusLabel.isEmpty ? 'Unknown' : statusLabel,
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (asset.hasGps ?? false)
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: Colors.blueGrey),
                          const SizedBox(width: 4),
                          Text('GPS', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey.shade600)),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
