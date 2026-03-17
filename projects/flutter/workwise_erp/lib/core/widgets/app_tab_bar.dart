import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/app_colors.dart';

/// A consistently styled pill-shaped tab bar used across all detail screens.
///
/// Wraps [TabBar] in the standard app container (rounded pill background,
/// primary-tinted indicator, no divider). The caller owns the [TabController]
/// and still builds the [TabBarView] directly — this widget only handles the
/// visual bar.
///
/// Usage:
/// ```dart
/// AppTabBar(
///   controller: _tabController,
///   tabs: const ['Overview', 'Items', 'History'],
/// )
/// ```
///
/// Pair it with a [TabBarView] using the same controller:
/// ```dart
/// Expanded(
///   child: TabBarView(
///     controller: _tabController,
///     physics: const BouncingScrollPhysics(),
///     children: [...],
///   ),
/// )
/// ```
class AppTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;

  /// Whether the tab bar scrolls horizontally. Defaults to [true] — use
  /// [false] only when the tab count is small enough to fill the bar evenly.
  final bool isScrollable;

  /// Outer margin of the pill container. Defaults to symmetric horizontal 16.
  final EdgeInsetsGeometry? margin;

  const AppTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.isScrollable = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary;

    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
        tabs: tabs.map((label) => Tab(text: label)).toList(),
        labelColor: isDark ? Colors.white : primary,
        labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        unselectedLabelColor: isDark ? Colors.white54 : Colors.grey.shade600,
        unselectedLabelStyle: TextStyle(fontSize: 13.sp),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: primary.withOpacity(0.15),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
    );
  }
}
