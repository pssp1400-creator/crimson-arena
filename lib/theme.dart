import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Crimson Arena Color Palette ──────────────────────────────
class CrimsonColors {
  static const bg       = Color(0xFF05060F);
  static const bg2      = Color(0xFF080B1A);
  static const panel    = Color(0x1A0C1028);
  static const border   = Color(0x38508CFF);
  static const blue     = Color(0xFF3B82F6);
  static const blueGlow = Color(0xFF60A5FA);
  static const purple   = Color(0xFFA855F7);
  static const purpleGl = Color(0xFFC084FC);
  static const crimson  = Color(0xFFEF4444);
  static const crimson2 = Color(0xFFDC2626);
  static const crimsonL = Color(0xFFF87171);
  static const cyan     = Color(0xFF22D3EE);
  static const green    = Color(0xFF22C55E);
  static const greenL   = Color(0xFF4ADE80);
  static const text     = Color(0xFFE2E8F0);
  static const muted    = Color(0xFF64748B);
}

// ── Text Styles ───────────────────────────────────────────────
class CrimsonText {
  static TextStyle hud({double size = 16, FontWeight weight = FontWeight.w700, Color color = CrimsonColors.text}) =>
    GoogleFonts.orbitron(fontSize: size, fontWeight: weight, color: color, letterSpacing: 0.08 * size);

  static TextStyle body({double size = 16, FontWeight weight = FontWeight.w500, Color color = CrimsonColors.text}) =>
    GoogleFonts.rajdhani(fontSize: size, fontWeight: weight, color: color);

  static TextStyle mono({double size = 14, Color color = CrimsonColors.text}) =>
    GoogleFonts.shareTechMono(fontSize: size, color: color, letterSpacing: 0.05 * size);
}

// ── Neon Shadows ─────────────────────────────────────────────
List<Shadow> neonBlue   = [Shadow(color: CrimsonColors.blueGlow.withOpacity(0.8),  blurRadius: 12), Shadow(color: CrimsonColors.blue.withOpacity(0.5),    blurRadius: 28)];
List<Shadow> neonPurple = [Shadow(color: CrimsonColors.purpleGl.withOpacity(0.8),  blurRadius: 12), Shadow(color: CrimsonColors.purple.withOpacity(0.5),   blurRadius: 28)];
List<Shadow> neonCrimson= [Shadow(color: CrimsonColors.crimsonL.withOpacity(0.9),  blurRadius: 12), Shadow(color: CrimsonColors.crimson.withOpacity(0.6),   blurRadius: 28)];
List<Shadow> neonGreen  = [Shadow(color: CrimsonColors.greenL.withOpacity(0.8),    blurRadius: 10)];
List<Shadow> neonCyan   = [Shadow(color: CrimsonColors.cyan.withOpacity(0.8),      blurRadius: 10)];

// ── App Theme ─────────────────────────────────────────────────
ThemeData crimsonTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: CrimsonColors.bg,
  colorScheme: const ColorScheme.dark(
    primary:   CrimsonColors.blue,
    secondary: CrimsonColors.purple,
    error:     CrimsonColors.crimson,
    surface:   CrimsonColors.bg2,
    onPrimary: Colors.white,
    onSurface: CrimsonColors.text,
  ),
  textTheme: TextTheme(
    displayLarge:  CrimsonText.hud(size: 48, weight: FontWeight.w900),
    displayMedium: CrimsonText.hud(size: 36, weight: FontWeight.w700),
    titleLarge:    CrimsonText.hud(size: 20, weight: FontWeight.w700),
    titleMedium:   CrimsonText.hud(size: 16, weight: FontWeight.w600),
    bodyLarge:     CrimsonText.body(size: 16),
    bodyMedium:    CrimsonText.body(size: 14),
    labelSmall:    CrimsonText.mono(size: 11, color: CrimsonColors.muted),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.04),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: CrimsonColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: CrimsonColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: CrimsonColors.blue, width: 1.5),
    ),
    labelStyle: CrimsonText.mono(size: 12, color: CrimsonColors.muted),
    hintStyle: CrimsonText.body(size: 14, color: CrimsonColors.muted),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: CrimsonColors.crimson2,
      foregroundColor: Colors.white,
      textStyle: CrimsonText.hud(size: 13, weight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: CrimsonColors.bg.withOpacity(0.88),
    elevation: 0,
    titleTextStyle: CrimsonText.hud(size: 14, weight: FontWeight.w900),
  ),
  useMaterial3: true,
);
