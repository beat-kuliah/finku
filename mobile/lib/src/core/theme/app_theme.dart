import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/core/theme/app_text_theme.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData get light => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = isDark
        ? const ColorScheme(
            brightness: Brightness.dark,
            primary: FinkuColors.cyan500,
            onPrimary: FinkuColors.ink900,
            primaryContainer: FinkuColors.blue800,
            onPrimaryContainer: Colors.white,
            secondary: FinkuColors.blue600,
            onSecondary: Colors.white,
            secondaryContainer: FinkuColors.ink700,
            onSecondaryContainer: Colors.white,
            tertiary: FinkuColors.cyan500,
            onTertiary: FinkuColors.ink900,
            error: FinkuColors.danger,
            onError: Colors.white,
            surface: FinkuColors.ink900,
            onSurface: Colors.white,
            surfaceContainerLowest: Color(0xFF080F1C),
            surfaceContainerLow: FinkuColors.ink900,
            surfaceContainer: FinkuColors.ink800,
            surfaceContainerHigh: Color(0xFF15233F),
            surfaceContainerHighest: FinkuColors.ink700,
            onSurfaceVariant: Color(0xCCFFFFFF),
            outline: Color(0x33FFFFFF),
            outlineVariant: Color(0x1AFFFFFF),
            inverseSurface: FinkuColors.lightBg,
            onInverseSurface: FinkuColors.lightText,
            inversePrimary: FinkuColors.blue800,
            shadow: Colors.black,
            scrim: Colors.black,
          )
        : const ColorScheme(
            brightness: Brightness.light,
            primary: FinkuColors.blue600,
            onPrimary: Colors.white,
            primaryContainer: Color(0xFFDBEAFE),
            onPrimaryContainer: FinkuColors.blue800,
            secondary: FinkuColors.blue800,
            onSecondary: Colors.white,
            secondaryContainer: Color(0xFFE0F2FE),
            onSecondaryContainer: FinkuColors.ink900,
            tertiary: FinkuColors.cyan500,
            onTertiary: FinkuColors.ink900,
            error: FinkuColors.danger,
            onError: Colors.white,
            surface: FinkuColors.lightBg,
            onSurface: FinkuColors.lightText,
            surfaceContainerLowest: Colors.white,
            surfaceContainerLow: Color(0xFFF1F5FB),
            surfaceContainer: Color(0xFFE8EFF8),
            surfaceContainerHigh: Color(0xFFDDE6F2),
            surfaceContainerHighest: Color(0xFFCFDBEC),
            onSurfaceVariant: FinkuColors.lightMuted,
            outline: Color(0x33000000),
            outlineVariant: Color(0x14000000),
            inverseSurface: FinkuColors.ink900,
            onInverseSurface: Colors.white,
            inversePrimary: FinkuColors.cyan500,
            shadow: Colors.black,
            scrim: Colors.black,
          );

    final onSurfaceMuted = isDark
        ? Colors.white.withValues(alpha: 0.62)
        : FinkuColors.lightMuted;
    final textTheme = AppTextTheme.build(
      onSurface: scheme.onSurface,
      onSurfaceMuted: onSurfaceMuted,
    );

    final glass = FinkuColors.glassTokens(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(color: scheme.onSurface, size: 22),
      primaryIconTheme: IconThemeData(color: scheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: glass.fill,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          side: BorderSide(color: glass.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glass.fill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: textTheme.bodyMedium?.copyWith(color: onSurfaceMuted),
        labelStyle: textTheme.bodyMedium?.copyWith(color: onSurfaceMuted),
        floatingLabelStyle: textTheme.labelLarge?.copyWith(color: scheme.primary),
        prefixIconColor: onSurfaceMuted,
        suffixIconColor: onSurfaceMuted,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: glass.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: glass.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.7), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: scheme.error.withValues(alpha: 0.6)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: glass.border),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          backgroundColor: glass.fill,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? FinkuColors.ink800 : Colors.white,
        modalBackgroundColor: isDark ? FinkuColors.ink800 : Colors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: scheme.outline,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? FinkuColors.ink800 : FinkuColors.ink900,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        actionTextColor: FinkuColors.cyan500,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return isDark ? Colors.white.withValues(alpha: 0.7) : Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary.withValues(alpha: 0.45);
          }
          return scheme.outlineVariant;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        circularTrackColor: scheme.outlineVariant,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        selectedIconTheme: IconThemeData(color: scheme.primary),
        unselectedIconTheme: IconThemeData(color: onSurfaceMuted),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(color: onSurfaceMuted),
      ),
    );
  }
}
