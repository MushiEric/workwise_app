import 'package:flutter/material.dart';

/// Breakpoint constants and helpers for responsive layouts.
///
/// Usage:
///   - [AppBreakpoints.isMobile] / [isTablet] / [isDesktop] for conditionals
///   - [AppBreakpoints.responsive] for providing different values per size class
class AppBreakpoints {
  AppBreakpoints._();

  /// Max width for mobile (< 600 dp)
  static const double mobileMaxWidth = 600;

  /// Max width for tablet (600 – 900 dp)
  static const double tabletMaxWidth = 900;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMaxWidth;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobileMaxWidth && w < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMaxWidth;

  /// Returns the appropriate value for the current screen-size class.
  ///
  /// Falls back to [mobile] if [tablet] / [desktop] are not provided.
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  /// Responsive horizontal padding: 16 on mobile, 24 on tablet, 40 on desktop.
  static double horizontalPadding(BuildContext context) =>
      responsive(context, mobile: 16.0, tablet: 24.0, desktop: 40.0);

  /// Max content width for centred layouts on wide screens.
  static double maxContentWidth(BuildContext context) =>
      responsive(context, mobile: double.infinity, tablet: 720, desktop: 1000);
}
