import 'package:flutter/material.dart';
import 'package:obatku/core/theme/app_colors.dart';
import 'package:obatku/core/constants/app_constants.dart';

class ObatkuStatusColors extends ThemeExtension<ObatkuStatusColors> {
  final Color safe;
  final Color safeContainer;
  final Color onSafeContainer;
  
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;

  final Color critical;
  final Color criticalContainer;
  final Color onCriticalContainer;

  const ObatkuStatusColors({
    required this.safe,
    required this.safeContainer,
    required this.onSafeContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.critical,
    required this.criticalContainer,
    required this.onCriticalContainer,
  });

  @override
  ThemeExtension<ObatkuStatusColors> copyWith({
    Color? safe,
    Color? safeContainer,
    Color? onSafeContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? critical,
    Color? criticalContainer,
    Color? onCriticalContainer,
  }) {
    return ObatkuStatusColors(
      safe: safe ?? this.safe,
      safeContainer: safeContainer ?? this.safeContainer,
      onSafeContainer: onSafeContainer ?? this.onSafeContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      critical: critical ?? this.critical,
      criticalContainer: criticalContainer ?? this.criticalContainer,
      onCriticalContainer: onCriticalContainer ?? this.onCriticalContainer,
    );
  }

  @override
  ThemeExtension<ObatkuStatusColors> lerp(ThemeExtension<ObatkuStatusColors>? other, double t) {
    if (other is! ObatkuStatusColors) {
      return this;
    }
    return ObatkuStatusColors(
      safe: Color.lerp(safe, other.safe, t)!,
      safeContainer: Color.lerp(safeContainer, other.safeContainer, t)!,
      onSafeContainer: Color.lerp(onSafeContainer, other.onSafeContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      critical: Color.lerp(critical, other.critical, t)!,
      criticalContainer: Color.lerp(criticalContainer, other.criticalContainer, t)!,
      onCriticalContainer: Color.lerp(onCriticalContainer, other.onCriticalContainer, t)!,
    );
  }
}

abstract final class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      colorScheme: const ColorScheme.light(
        primary: AppColors.deepGreen,
        secondary: AppColors.forestGreen,
        tertiary: AppColors.mintAccent,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        error: AppColors.criticalRed,
        onError: Colors.white,
        outline: AppColors.border,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(AppConstants.touchTargetSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.deepGreen, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.deepGreen, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.criticalRed, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.deepGreen,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 8,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.deepGreen,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      extensions: const [
        ObatkuStatusColors(
          safe: AppColors.safeGreen,
          safeContainer: AppColors.safeContainer,
          onSafeContainer: AppColors.safeGreen,
          warning: AppColors.warningYellow,
          warningContainer: AppColors.warningContainer,
          onWarningContainer: AppColors.warningYellow,
          critical: AppColors.criticalRed,
          criticalContainer: AppColors.criticalContainer,
          onCriticalContainer: AppColors.criticalRed,
        ),
      ],
    );
  }

  static Widget clampTextScale(BuildContext context, Widget? child) {
    final mediaQueryData = MediaQuery.of(context);
    final clampedTextScaleFactor = mediaQueryData.textScaler.clamp(
      minScaleFactor: 1.0,
      maxScaleFactor: AppConstants.maxTextScale,
    );
    return MediaQuery(
      data: mediaQueryData.copyWith(textScaler: clampedTextScaleFactor),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
