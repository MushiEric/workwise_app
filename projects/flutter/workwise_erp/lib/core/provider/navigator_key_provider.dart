import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global navigator key — passed to [MaterialApp.navigatorKey] so interceptors
/// and other non-widget code can trigger navigation without a [BuildContext].
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (_) => GlobalKey<NavigatorState>(),
);

/// Global scaffold messenger key — passed to [MaterialApp.scaffoldMessengerKey]
/// so interceptors can show snack-bars without a [BuildContext].
final scaffoldMessengerKeyProvider =
    Provider<GlobalKey<ScaffoldMessengerState>>(
      (_) => GlobalKey<ScaffoldMessengerState>(),
    );
