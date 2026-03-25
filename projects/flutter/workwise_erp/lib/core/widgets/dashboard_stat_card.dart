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
  final String? valueText;
  final IconData icon;
  final Color borderColor;

  const DashboardStatCard({
    super.key,
    required this.label,
    this.count = 0,
    this.valueText,
    required this.icon,
    required this.borderColor,
  });

  Color _iconColor(Color borderColor, bool isDark) {
    // Ensure icon is visible even when the border color is very light.
    final luminance = borderColor.computeLuminance();
    if (luminance > 0.8) {
      return isDark
          ? Colors.white.withOpacity(0.24)
          : Colors.black.withOpacity(0.24);
    }
    return borderColor.withOpacity(0.48);
  }

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
                  valueText ?? count.toString(),
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
            opacity: 0.18,
            child: Icon(
              icon,
              size: 40.r,
              color: _iconColor(borderColor, isDark),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardStatCardSkeleton extends StatelessWidget {
  const DashboardStatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.white12 : Colors.grey.shade200;

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
          left: BorderSide(color: base.withOpacity(0.8), width: 3.w),
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
                Container(
                  height: 12.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  height: 18.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }
}
