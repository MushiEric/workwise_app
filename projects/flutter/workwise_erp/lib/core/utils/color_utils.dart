import 'package:flutter/material.dart';

/// Convert common hex color string formats to [Color].
///
/// Accepted forms:
/// - `#RRGGBB` (e.g. `#457af7`)
/// - `RRGGBB` (e.g. `457af7`)
/// - `0xAARRGGBB` or `AARRGGBB` (alpha-prefixed)
///
/// Returns [fallback] when parsing fails or input is null/empty.
Color hexToColor(String? hex, {Color? fallback}) {
  final fb = fallback ?? Colors.transparent;
  if (hex == null) return fb;

  var s = hex.trim();
  if (s.isEmpty) return fb;

  // Remove leading # if present
  if (s.startsWith('#')) s = s.substring(1);
  // Remove 0x if present
  if (s.startsWith('0x')) s = s.replaceFirst('0x', '');

  // Now s should be RRGGBB or AARRGGBB
  try {
    if (s.length == 3) {
      // short hex e.g. '0f8' -> '00ff88' (expand each digit)
      final r = s[0];
      final g = s[1];
      final b = s[2];
      s = '$r$r$g$g$b$b';
    }

    if (s.length == 6) {
      s = 'FF' + s; // add full opacity
    }

    if (s.length != 8) return fb;

    final intVal = int.parse(s, radix: 16);
    return Color(intVal);
  } catch (_) {
    return fb;
  }
}
