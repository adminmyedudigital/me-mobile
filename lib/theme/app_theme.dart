import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

final class AppTheme {
  const AppTheme._();

  static final AppColors lightColors = AppColors.brand();
  static final AppColors darkColors = AppColors.brand();

  static ThemeData get light => _build(lightColors, Brightness.dark);
  static ThemeData get dark => _build(darkColors, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final textTheme = AppTypography.textTheme(colors);
    final buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.button);
    final inputBorder = OutlineInputBorder(
      borderRadius: AppRadius.input,
      borderSide: BorderSide(color: colors.hairlineStrong),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTypography.uiFont,
      fontFamilyFallback: AppTypography.bodyFallback,
      scaffoldBackgroundColor: colors.canvas,
      canvasColor: colors.canvas,
      cardColor: colors.surfaceCard,
      dividerColor: colors.dividerSoft,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.primaryOn,
        secondary: colors.surfaceElevated,
        onSecondary: colors.ink,
        error: colors.accentRed,
        onError: colors.ink,
        surface: colors.canvas,
        onSurface: colors.ink,
        surfaceContainerLow: colors.surfaceDeep,
        surfaceContainer: colors.surfaceCard,
        surfaceContainerHigh: colors.surfaceElevated,
        outline: colors.hairline,
        outlineVariant: colors.hairlineStrong,
      ),
      extensions: [colors],
      textTheme: textTheme,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.ink,
        selectionColor: colors.accentBlueGlow,
        selectionHandleColor: colors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.ink,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colors.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: colors.hairlineStrong),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceElevated,
        disabledColor: colors.surfaceCard,
        selectedColor: colors.surfaceElevated,
        secondarySelectedColor: colors.surfaceElevated,
        labelStyle: AppTypography.caption(colors).copyWith(color: colors.body),
        secondaryLabelStyle: AppTypography.caption(
          colors,
        ).copyWith(color: colors.ink),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: StadiumBorder(side: BorderSide(color: colors.hairline)),
        side: BorderSide(color: colors.hairline),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: AppSpacing.button,
          backgroundColor: colors.primary,
          foregroundColor: colors.primaryOn,
          disabledBackgroundColor: colors.stone,
          disabledForegroundColor: colors.mute,
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: AppTypography.buttonMd(colors),
          shape: buttonShape,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: AppSpacing.button,
          backgroundColor: colors.primary,
          foregroundColor: colors.primaryOn,
          disabledBackgroundColor: colors.stone,
          disabledForegroundColor: colors.mute,
          textStyle: AppTypography.buttonMd(colors),
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: AppSpacing.button,
          backgroundColor: colors.canvas,
          foregroundColor: colors.ink,
          disabledForegroundColor: colors.stone,
          side: BorderSide(color: colors.hairlineStrong),
          textStyle: AppTypography.buttonMd(colors),
          shape: buttonShape,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.primaryOn,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceCard,
        contentPadding: AppSpacing.input,
        hintStyle: TextStyle(color: colors.mute),
        labelStyle: TextStyle(color: colors.charcoal),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: colors.ink, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: colors.accentRed),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: AppSpacing.button,
          foregroundColor: colors.link,
          textStyle: AppTypography.buttonSm(colors),
          shape: buttonShape,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.dividerSoft,
        space: 1,
        thickness: 1,
      ),
      iconTheme: IconThemeData(color: colors.ink),
      listTileTheme: ListTileThemeData(
        iconColor: colors.charcoal,
        textColor: colors.body,
        titleTextStyle: AppTypography.bodyMd(
          colors,
        ).copyWith(color: colors.ink),
        subtitleTextStyle: AppTypography.bodySm(colors),
      ),
    );
  }
}
