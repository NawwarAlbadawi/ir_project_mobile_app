import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppColors {
  static const bgBase      = Color(0xFF0A0D14);
  static const bgSurface   = Color(0xFF111827);
  static const bgElevated  = Color(0xFF1A2235);
  static const bgGlass     = Color(0xB31A2235);
  static const accent      = Color(0xFF6366F1);
  static const accentLight = Color(0xFF818CF8);
  static const accentCyan  = Color(0xFF06B6D4);
  static const accentPink  = Color(0xFFEC4899);
  static const accentGreen = Color(0xFF10B981);
  static const accentAmber = Color(0xFFF59E0B);
  static const textPrimary   = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted     = Color(0xFF475569);
  static const border      = Color(0x336366F1);
  static const borderHover = Color(0x806366F1);
  static const sparseColor  = Color(0xFF818CF8);
  static const denseColor   = Color(0xFF06B6D4);
  static const hybridColor  = Color(0xFFEC4899);
}
class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgBase,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentCyan,
        surface: AppColors.bgSurface,
        error: AppColors.accentPink,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary, letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary, letterSpacing: -0.3,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, color: AppColors.textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12, color: AppColors.textMuted,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgBase.withOpacity(0.85),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgGlass,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgElevated,
        hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent,
        thumbColor: Colors.white,
        inactiveTrackColor: AppColors.border,
        overlayColor: AppColors.accent.withOpacity(0.2),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgElevated,
        selectedColor: AppColors.accent.withOpacity(0.25),
        labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13),
        side: const BorderSide(color: AppColors.border),
        shape: const StadiumBorder(),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgSurface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}