import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A compact statistics card used on list screens (jobcards, support, etc.).
///
/// Features:
/// - Left border accent in [borderColor] — driven by status colour from backend
/// - Faded background [icon] for visual context
/// - [label] and [count] display
/// - Adapts to light / dark theme automatically
class DashboardStatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color borderColor;

  const DashboardStatCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 75.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0E21) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          left: BorderSide(color: borderColor, width: 3.w),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Opacity(
            opacity: 0.12,
            child: Icon(icon, size: 40.r, color: borderColor),
          ),
        ],
      ),
    );
  }
}
