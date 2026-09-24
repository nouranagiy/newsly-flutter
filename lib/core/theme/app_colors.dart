import 'package:flutter/material.dart';

@immutable
class AppPalette {
  final Color canvas;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color borderStrong;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color primary;
  final Color primaryStrong;
  final Color primarySoft;
  final Color onPrimary;

  final Color accent;
  final Color accentSoft;

  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color error;
  final Color errorSoft;

  final Color shadow;

  const AppPalette({
    required this.canvas,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.primaryStrong,
    required this.primarySoft,
    required this.onPrimary,
    required this.accent,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.error,
    required this.errorSoft,
    required this.shadow,
  });

  static const AppPalette light = AppPalette(
    canvas: Color(0xFFF5F6F8),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF1F2F6),
    border: Color(0xFFE4E6EB),
    borderStrong: Color(0xFFD2D5DD),
    textPrimary: Color(0xFF1A1B25),
    textSecondary: Color(0xFF57596A),
    textMuted: Color(0xFF989BA8),
    primary: Color(0xFF4F46E5),
    primaryStrong: Color(0xFF4338CA),
    primarySoft: Color(0xFFEEF0FF),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFF7C3AED),
    accentSoft: Color(0xFFF4EEFF),
    success: Color(0xFF16A34A),
    successSoft: Color(0xFFE7F5EC),
    warning: Color(0xFFD97706),
    warningSoft: Color(0xFFFBF1DE),
    error: Color(0xFFDC2626),
    errorSoft: Color(0xFFFCEBEB),
    shadow: Color(0x1416161F),
  );

  static const AppPalette dark = AppPalette(
    canvas: Color(0xFF0A0A0D),
    surface: Color(0xFF141418),
    surfaceMuted: Color(0xFF1B1B21),
    border: Color(0xFF2A2A32),
    borderStrong: Color(0xFF3A3A45),
    textPrimary: Color(0xFFF5F5F7),
    textSecondary: Color(0xFFB6B8C3),
    textMuted: Color(0xFF7C7F8E),
    primary: Color(0xFF6D69FF),
    primaryStrong: Color(0xFF8A86FF),
    primarySoft: Color(0xFF262549),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFA78BFA),
    accentSoft: Color(0xFF2E2747),
    success: Color(0xFF34D399),
    successSoft: Color(0xFF123B2A),
    warning: Color(0xFFFBBF24),
    warningSoft: Color(0xFF3A2E11),
    error: Color(0xFFF87171),
    errorSoft: Color(0xFF40201F),
    shadow: Color(0x2E000000),
  );

  ColorScheme toColorScheme(Brightness brightness) => ColorScheme(
    brightness: brightness,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primarySoft,
    onPrimaryContainer: primaryStrong,
    secondary: accent,
    onSecondary: onPrimary,
    secondaryContainer: accentSoft,
    onSecondaryContainer: accent,
    error: error,
    onError: Colors.white,
    errorContainer: errorSoft,
    onErrorContainer: error,
    surface: surface,
    onSurface: textPrimary,
    surfaceContainerLowest: surface,
    surfaceContainerLow: surfaceMuted,
    surfaceContainer: surfaceMuted,
    surfaceContainerHigh: surface,
    surfaceContainerHighest: surface,
    onSurfaceVariant: textSecondary,
    outline: border,
    outlineVariant: borderStrong,
    shadow: shadow,
    scrim: Color(0x66000000),
  );
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).brightness == Brightness.dark
      ? AppPalette.dark
      : AppPalette.light;
}
