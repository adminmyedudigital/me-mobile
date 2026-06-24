import 'package:flutter/material.dart';

import 'app_colors.dart';

final class AppTypography {
  const AppTypography._();

  static const String displayFont = 'Domaine Display';
  static const String bodyFont = 'ABC Favorit';
  static const String uiFont = 'Inter';
  static const String monoFont = 'Geist Mono';

  static const List<String> displayFallback = [
    'Tiempos Headline',
    'Georgia',
    'serif',
  ];
  static const List<String> bodyFallback = [
    'Inter Tight',
    'Inter',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];
  static const List<String> monoFallback = [
    'Menlo',
    'Monaco',
    'Consolas',
    'monospace',
  ];

  static TextStyle displayXxl(AppColors colors) => TextStyle(
    color: colors.ink,
    fontFamily: displayFont,
    fontFamilyFallback: displayFallback,
    fontSize: 96,
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: -0.96,
  );

  static TextStyle displayXl(AppColors colors) =>
      displayXxl(colors).copyWith(fontSize: 76.8, letterSpacing: -0.768);

  static TextStyle displayLg(AppColors colors) => TextStyle(
    color: colors.ink,
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFallback,
    fontSize: 56,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -2.8,
  );

  static TextStyle headingMd(AppColors colors) => TextStyle(
    color: colors.ink,
    fontFamily: uiFont,
    fontFamilyFallback: bodyFallback,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.4,
  );

  static TextStyle headingSm(AppColors colors) => headingMd(
    colors,
  ).copyWith(fontSize: 20, height: 1.3, letterSpacing: -0.3);

  static TextStyle subtitle(AppColors colors) => TextStyle(
    color: colors.body,
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFallback,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static TextStyle bodyLg(AppColors colors) => TextStyle(
    color: colors.body,
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFallback,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMd(AppColors colors) =>
      bodyLg(colors).copyWith(fontSize: 16, letterSpacing: -0.8);

  static TextStyle bodySm(AppColors colors) => TextStyle(
    color: colors.charcoal,
    fontFamily: uiFont,
    fontFamilyFallback: bodyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );

  static TextStyle buttonMd(AppColors colors) => TextStyle(
    color: colors.primaryOn,
    fontFamily: uiFont,
    fontFamilyFallback: bodyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );

  static TextStyle buttonSm(AppColors colors) =>
      buttonMd(colors).copyWith(color: colors.body, letterSpacing: 0.35);

  static TextStyle caption(AppColors colors) => TextStyle(
    color: colors.ash,
    fontFamily: uiFont,
    fontFamilyFallback: bodyFallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle captionEmph(AppColors colors) => TextStyle(
    color: colors.ink,
    fontFamily: uiFont,
    fontFamilyFallback: bodyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1,
  );

  static TextStyle codeMd(AppColors colors) => TextStyle(
    color: colors.body,
    fontFamily: monoFont,
    fontFamilyFallback: monoFallback,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextTheme textTheme(AppColors colors) {
    return TextTheme(
      displayLarge: displayXxl(colors),
      displayMedium: displayXl(colors),
      displaySmall: displayLg(colors),
      headlineMedium: headingMd(colors),
      headlineSmall: headingSm(colors),
      titleLarge: headingMd(colors),
      titleMedium: subtitle(colors),
      bodyLarge: bodyLg(colors),
      bodyMedium: bodyMd(colors),
      bodySmall: bodySm(colors),
      labelLarge: buttonMd(colors),
      labelMedium: buttonSm(colors),
      labelSmall: caption(colors),
    );
  }
}
