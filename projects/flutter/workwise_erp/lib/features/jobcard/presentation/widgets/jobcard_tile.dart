import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/jobcard.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/color_utils.dart';

class JobcardTile extends StatelessWidget {
  final Jobcard jobcard;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const JobcardTile({
    super.key,
    required this.jobcard,
    this.onTap,
    this.onDelete,
  });

  Color _getStatusColor(String? statusName) {
    if (statusName == null || statusName.isEmpty) return AppColors.primary;
    final lower = statusName.toLowerCase();
    if (lower.contains('open')) return const Color(0xFF4A6FA5);
    if (lower.contains('completed') || lower.contains('done') || lower.contains('closed')) {
      return Colors.green;
    }
    if (lower.contains('pending') || lower.contains('waiting')) return Colors.orange;
    if (lower.contains('in progress') || lower.contains('processing')) return Colors.blue;
    if (lower.contains('cancelled') || lower.contains('rejected')) return Colors.red;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusName = jobcard.statusRow?['name']?.toString() ?? '';
    Color statusColor = _getStatusColor(statusName.isNotEmpty ? statusName : jobcard.status);

    // Prefer explicit color from backend status_row if provided
    final rowColorStr = jobcard.statusRow?['color']?.toString();
    if (rowColorStr != null && rowColorStr.isNotEmpty) {
      statusColor = hexToColor(rowColorStr, fallback: statusColor);
    }

    final displayStatus = statusName.isNotEmpty ? statusName : (jobcard.status ?? 'Unknown');

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      color: isDark ? const Color(0xFF151A2E) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row: JC chip · jobcard number · status badge ──
              Row(
                children: [
                  // Type chip
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'JC',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Jobcard number
                  Expanded(
                    child: Text(
                      jobcard.jobcardNumber ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                        fontSize: 13.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          displayStatus,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Delete action
                  if (onDelete != null) ...[
                    SizedBox(width: 4.w),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 18.r,
                        color: isDark ? Colors.white38 : AppColors.error,
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
                    ),
                  ],
                ],
              ),

              SizedBox(height: 12.h),

              // ── Service title ──
              Text(
                jobcard.service ?? 'No service',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 8.h),

              // ── Items row ──
              Row(
                children: [
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.inventory_2_rounded,
                      size: 14.r,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      jobcard.itemsCount != null && jobcard.itemsCount! > 0
                          ? '${jobcard.itemsCount} item${jobcard.itemsCount! > 1 ? 's' : ''}'
                          : 'No items',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // ── Footer: date + grand total ──
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14.r,
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    jobcard.reportedDate ?? 'No date',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                  const Spacer(),
                  if (jobcard.grandTotal != null && jobcard.grandTotal!.isNotEmpty) ...[
                    Icon(
                      Icons.attach_money_rounded,
                      size: 16.r,
                      color: isDark ? Colors.white38 : Colors.grey.shade400,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      jobcard.grandTotal!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF1A2634),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
