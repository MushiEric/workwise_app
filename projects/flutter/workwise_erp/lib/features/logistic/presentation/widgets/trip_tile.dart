import 'package:flutter/material.dart';

import '../../domain/entities/trip.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/color_utils.dart';

class TripTile extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const TripTile({super.key, required this.trip, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = hexToColor(trip.statusColor, fallback: AppColors.muted);
    final statusLabel = trip.statusName ?? 'Unknown';
    final isNaRoute = trip.routeName == null || trip.routeName == 'N/A';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: trip number badge + status chip ──────────────
                Row(
                  children: [
                    // Trip number badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        trip.tripNumber ?? '—',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          letterSpacing: 0.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Status chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Route ─────────────────────────────────────────────────
                if (!isNaRoute)
                  _InfoRow(
                    icon: Icons.route_rounded,
                    text: trip.routeName!,
                    color: AppColors.primary,
                    bold: true,
                  ),
                if (!isNaRoute) const SizedBox(height: 6),

                // ── Customer ──────────────────────────────────────────────
                if (trip.customerName != null)
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    text: trip.customerName!,
                    isDark: isDark,
                  ),
                if (trip.customerName != null) const SizedBox(height: 4),

                // ── Vehicle + Operator ────────────────────────────────────
                Row(
                  children: [
                    if (trip.vehicleNumber != null && trip.vehicleNumber != 'N/A') ...[
                      Expanded(
                        child: _InfoRow(
                          icon: Icons.local_shipping_rounded,
                          text: trip.vehicleNumber!,
                          isDark: isDark,
                        ),
                      ),
                    ],
                    if (trip.operatorName != null && trip.operatorName != 'N/A') ...[
                      Expanded(
                        child: _InfoRow(
                          icon: Icons.drive_eta_rounded,
                          text: trip.operatorName!,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ],
                ),

                // ── ETD / ETAS ────────────────────────────────────────────
                if (trip.etd != null || trip.etas != null) ...[
                  const SizedBox(height: 8),
                  Divider(
                    height: 1,
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (trip.etd != null)
                        Expanded(
                          child: _DateChip(label: 'ETD', value: trip.etd!, isDark: isDark),
                        ),
                      if (trip.etd != null && trip.etas != null)
                        const SizedBox(width: 8),
                      if (trip.etas != null)
                        Expanded(
                          child: _DateChip(label: 'ETA', value: trip.etas!, isDark: isDark),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  final bool bold;
  final Color? color;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.isDark = false,
    this.bold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? (isDark ? Colors.white70 : Colors.grey.shade700);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: textColor),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
              color: bold ? (color ?? (isDark ? Colors.white : const Color(0xFF1A2634))) : textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _DateChip({required this.label, required this.value, required this.isDark});

  /// Trims seconds off datetime strings like "2026-02-05 12:33:35"
  String _fmt(String v) {
    final parts = v.split(' ');
    if (parts.length == 2) {
      final timeParts = parts[1].split(':');
      if (timeParts.length >= 2) return '${parts[0]}  ${timeParts[0]}:${timeParts[1]}';
    }
    return v;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label  ',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: Text(
              _fmt(value),
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
