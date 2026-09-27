import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:obatku/core/theme/app_theme.dart';
import 'package:obatku/core/router/app_router.dart';
import 'package:obatku/core/constants/app_constants.dart';

/// Widget root aplikasi OBATKU.
///
/// Mengonfigurasi tema Material Design 3, lokalisasi Bahasa Indonesia,
/// pembatas skala teks, serta router navigasi utama.
class ObatkuApp extends ConsumerWidget {
  const ObatkuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Tema Material Design 3 dengan palet medis
      theme: AppTheme.lightTheme,

      // Lokalisasi Bahasa Indonesia
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'), // Bahasa Indonesia (utama)
        Locale('en', 'US'), // English (fallback)
      ],
      locale: const Locale('id', 'ID'),

      // Navigasi GoRouter
      routerConfig: appRouter,

      // Pembatas skala teks untuk mencegah overflow layout
      // pada perangkat dengan pengaturan font besar
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.textScalerOf(context).clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: AppConstants.maxTextScale,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
