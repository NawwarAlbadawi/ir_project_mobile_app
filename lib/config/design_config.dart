import 'package:flutter/material.dart';
abstract class DesignConfig {
  static const double defaultBorderRadius = 14;
  static const double largeBorderRadius = 20;
  static const double chipRadius = 999;
  static final borderRadius = BorderRadius.circular(defaultBorderRadius);
  static final largeBorderRadiusFull = BorderRadius.circular(largeBorderRadius);
  static const double horizontalPadding = 20;
  static const double verticalPadding = 12;
  static final List<BoxShadow> glowShadow = [
    BoxShadow(
      color: AppColors.accent.withOpacity(0.18),
      blurRadius: 30,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.35),
      blurRadius: 24,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];
  static const Gradient primaryGradient = LinearGradient(
    colors: [AppColors.accent, Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Gradient titleGradient = LinearGradient(
    colors: [AppColors.accent, AppColors.accentCyan],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static BoxDecoration get glassDecoration => BoxDecoration(
        color: AppColors.bgGlass,
        borderRadius: borderRadius,
        border: Border.all(color: AppColors.border),
      );
}
abstract class AppColors {
  static const bgBase     = Color(0xFF0A0D14);
  static const bgSurface  = Color(0xFF111827);
  static const bgElevated = Color(0xFF1A2235);
  static const bgGlass    = Color(0xB31A2235);
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
}