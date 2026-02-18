import 'package:flutter/material.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';

import '../../domain/entities/operator.dart';
import '../../../../core/themes/app_colors.dart';

class OperatorTile extends StatelessWidget {
  final Operator operatorModel;
  final VoidCallback? onTap;

  const OperatorTile({super.key, required this.operatorModel, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary;

    final title = operatorModel.name ?? 'Unnamed driver';
  final subtitleParts = <String>[];
  if (operatorModel.phone != null && operatorModel.phone!.isNotEmpty) subtitleParts.add(operatorModel.phone!);
  if (operatorModel.email != null && operatorModel.email!.isNotEmpty) subtitleParts.add(operatorModel.email!);
  final subtitle = subtitleParts.join('\n');
    Color statusColor = primary;
    final status = (operatorModel.status ?? '').toLowerCase();
    if (status.contains('inactive') || status.contains('off')) statusColor = Colors.grey;
    if (status.contains('unavailable') || status.contains('busy')) statusColor = Colors.orange;
    if (status.contains('available') || status.contains('active')) statusColor = Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200, width: 1),
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
                CircleAvatar(
                  radius: 26,
                  backgroundColor: primary.withOpacity(0.08),
                  backgroundImage: imageProviderFromUrl(operatorModel.avatar),
                  child: operatorModel.avatar == null || operatorModel.avatar!.isEmpty ? Icon(Icons.person, color: primary) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1A2634))),
                      const SizedBox(height: 6),
                      if (subtitle.isNotEmpty)
                        Text(subtitle, style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(
                        status.isEmpty ? 'Unknown' : status[0].toUpperCase() + status.substring(1),
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
