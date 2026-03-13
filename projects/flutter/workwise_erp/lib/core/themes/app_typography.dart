import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized typography for the app.
/// - Default body: Inter (via GoogleFonts)
/// - Titles & numeric displays: Figtree
class AppTypography {
  AppTypography._();

  /// Application-wide TextTheme (base = Inter, override titles → Figtree)
  static final TextTheme textTheme = GoogleFonts.interTextTheme().copyWith(
    // Titles (use Figtree)
    titleLarge: GoogleFonts.figtree(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      letterSpacing: 0.2,
    ),
    titleMedium: GoogleFonts.figtree(fontWeight: FontWeight.w600, fontSize: 16),
    headlineMedium: GoogleFonts.figtree(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),

    // Body / small text (Inter)
    bodyMedium: GoogleFonts.inter(fontSize: 14),
    bodySmall: GoogleFonts.inter(fontSize: 12),
  );

  /// Use for tabular/numeric displays (figtree + tabular figures)
  static TextStyle number({
    double fontSize = 16,
    FontWeight weight = FontWeight.w600,
  }) => GoogleFonts.figtree(
    fontSize: fontSize,
    fontWeight: weight,
  ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

    static const double borderRadius = 12.0;

     static const TextStyle hintStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF999999),
  );

  static const double buttonBorderRadius = 8.0;


  // Convenience getters
  static TextStyle get title => textTheme.titleLarge!;
  static TextStyle get bodySmall => textTheme.bodySmall!;
    static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF333333),
  );
}
