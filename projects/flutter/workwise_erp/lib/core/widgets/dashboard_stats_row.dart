import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dashboard_stat_card.dart';

/// A horizontally scrollable row of [DashboardStatCard]s with animated
/// show / hide support.
///
/// Visibility is controlled by the caller via [visible] (typically toggled by
/// an eye-icon button in the page's AppBar). The row animates in and out
/// smoothly using [AnimatedSwitcher].
///
/// Usage:
/// ```dart
/// DashboardStatsRow(
///   visible: _showStats,
///   cards: [
///     DashboardStatCard(label: 'Total', count: 42, icon: Icons.list, borderColor: AppColors.primary),
///     DashboardStatCard(label: 'Open',  count: 10, icon: Icons.lock_open, borderColor: Colors.blue),
///   ],
/// )
/// ```
class DashboardStatsRow extends StatelessWidget {
  final List<DashboardStatCard> cards;
  final bool visible;

  const DashboardStatsRow({
    super.key,
    required this.cards,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: visible
          ? Padding(
              key: const ValueKey('stats-visible'),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: SizedBox(
                height: 96.h,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < cards.length; i++) ...[
                        if (i > 0) SizedBox(width: 12.w),
                        SizedBox(width: 150.w, child: cards[i]),
                      ],
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('stats-hidden')),
    );
  }
}
