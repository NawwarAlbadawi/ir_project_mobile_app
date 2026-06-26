// =============================================================================
// lib/config/theme/theme.dart
// Dark theme — mirrors gym_mobile_app's theme structure.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_config.dart';

final  darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.bgBase,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accent,
    primaryContainer: Color(0xFF4F46E5),
    secondary: AppColors.accentCyan,
    secondaryContainer: Color(0xFF0891B2),
    surface: AppColors.bgSurface,
    error: AppColors.accentPink,
    onPrimary: Colors.white,
    onSurface: AppColors.textPrimary,
    outline: AppColors.border,
    outlineVariant: AppColors.border,
  ),
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      letterSpacing: -0.3,
    ),
    iconTheme: const IconThemeData(color: AppColors.textSecondary),
  ),
  cardTheme: CardThemeData(
    color: AppColors.bgGlass,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: DesignConfig.borderRadius,
      side: const BorderSide(color: AppColors.border),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.bgElevated,
    hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: DesignConfig.borderRadius,
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: DesignConfig.borderRadius,
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: DesignConfig.borderRadius,
      borderSide: const BorderSide(color: AppColors.accent, width: 2),
    ),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.accent,
    thumbColor: Colors.white,
    inactiveTrackColor: AppColors.border,
    overlayColor: AppColors.accent.withOpacity(0.15),
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.border,
    thickness: 1,
    space: 0,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.bgElevated,
    selectedColor: AppColors.accent.withOpacity(0.25),
    labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13),
    side: const BorderSide(color: AppColors.border),
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 4),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.bgSurface,
    selectedItemColor: AppColors.accent,
    unselectedItemColor: AppColors.textMuted,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
);
