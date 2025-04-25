import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'typography.dart';

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  // ➊ Επιλογή seed & background κατευθείαν
  final seedColor  = isDark ? AppColorsDark.primary   : AppColorsLight.primary;
  final surface    = isDark ? AppColorsDark.surface   : AppColorsLight.surface;
  final onSurface  = isDark ? AppColorsDark.onSurface : AppColorsLight.onSurface;
  final error      = isDark ? AppColorsDark.error     : AppColorsLight.error;
  final onPrimary  = isDark ? AppColorsDark.onPrimary : AppColorsLight.onPrimary;

  // ➋ Πλήρες ColorScheme από seed
  final scheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  ).copyWith(
    surface: surface,
    onSurface: onSurface,
    error: error,
    onError: onPrimary,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: surface,
    textTheme: AppTypography.textTheme,
  );
}
