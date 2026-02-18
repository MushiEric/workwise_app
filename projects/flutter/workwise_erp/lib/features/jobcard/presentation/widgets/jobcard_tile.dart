import 'package:flutter/material.dart';
import '../../domain/entities/jobcard.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/utils/color_utils.dart';

class JobcardTile extends StatelessWidget {
  final Jobcard jobcard;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const JobcardTile({super.key, required this.jobcard, this.onTap, this.onDelete});

  Color _statusColor(String? status) {
    switch (status) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.blue;
      case '4':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  Color _getStatusColorFromName(String? statusName) {
    if (statusName == null) return AppColors.primary;
    final lower = statusName.toLowerCase();
    if (lower.contains('completed') || lower.contains('done') || lower.contains('closed')) {
      return Colors.green;
    } else if (lower.contains('pending') || lower.contains('waiting')) {
      return Colors.orange;
    } else if (lower.contains('in progress') || lower.contains('processing')) {
      return Colors.blue;
    } else if (lower.contains('cancelled') || lower.contains('rejected')) {
      return Colors.red;
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusName = jobcard.statusRow?['name']?.toString() ?? '';
    Color statusColor = statusName.isNotEmpty 
        ? _getStatusColorFromName(statusName)
        : _statusColor(jobcard.status);

    // Prefer explicit color from backend status_row if provided
    final rowColorStr = jobcard.statusRow?['color']?.toString();
    if (rowColorStr != null && rowColorStr.isNotEmpty) {
      statusColor = hexToColor(rowColorStr, fallback: statusColor);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.primary.withOpacity(0.05),
          highlightColor: AppColors.primary.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Jobcard Details and Status (SWAPPED)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Jobcard Details (now on the left)
                    Expanded(
                      child: Row(
                        children: [
                          // Icon with gradient background
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withOpacity(0.15),
                                  AppColors.primary.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.assignment_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Jobcard details (service and jobcard number)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Service/Title (now first/primary)
                                if (jobcard.service != null && jobcard.service!.isNotEmpty) ...[
                                  Text(
                                    jobcard.service!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                
                                // Jobcard Number (now secondary)
                                Row(
                                  children: [
                                    // Icon(
                                    //   Icons.confirmation_number_rounded,
                                    //   size: 12,
                                    //   color: isDark ? Colors.white38 : Colors.grey.shade500,
                                    // ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        jobcard.jobcardNumber ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Status and Delete (on the right)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Status Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.muted,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                statusName.isNotEmpty ? statusName : (jobcard.status ?? 'Unknown'),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Delete action (optional)
                        if (onDelete != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: isDark ? Colors.white38 : AppColors.error,
                              ),
                              onPressed: onDelete,
                              splashRadius: 20,
                              tooltip: 'Delete',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Divider with subtle styling
                Container(
                  height: 1,
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                ),

                const SizedBox(height: 12),

                // Footer with Date, Items Count and Amount
                Row(
                  children: [
                    // Date with icon
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 12,
                            color: isDark ? Colors.white38 : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            jobcard.reportedDate ?? 'No date',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Items count
                    if (jobcard.itemsCount != null && jobcard.itemsCount! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.inventory_2_rounded,
                              size: 12,
                              color: isDark ? Colors.white38 : Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${jobcard.itemsCount} item${jobcard.itemsCount! > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white54 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const Spacer(),
                    
                    // Grand Total
                    if (jobcard.grandTotal != null && jobcard.grandTotal!.isNotEmpty)
                      Text(
                        jobcard.grandTotal!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
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