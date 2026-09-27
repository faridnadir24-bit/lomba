import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obatku/features/dashboard/presentation/dashboard_screen.dart';
import 'package:obatku/features/inventory/presentation/inventory_screen.dart';
import 'package:obatku/features/expiry_warning/presentation/expiry_warning_screen.dart';
import 'package:obatku/features/prediction/presentation/prediction_screen.dart';
import 'package:obatku/features/sync/presentation/sync_screen.dart';
import 'package:obatku/features/add_medicine/presentation/add_medicine_screen.dart';
import 'package:obatku/features/inventory/presentation/medicine_detail_screen.dart';
import 'package:obatku/core/theme/app_colors.dart';

/// Konfigurasi rute navigasi utama OBATKU.
///
/// Menggunakan [ShellRoute] dengan [NavigationBar] (bottom navigation)
/// untuk 4 tab utama + 1 menu tambahan, sesuai prinsip Material Design 3
/// yang merekomendasikan 3-5 item di navigation bar.
final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/inventory',
          name: 'inventory',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: InventoryScreen(),
          ),
          routes: [
            GoRoute(
              path: 'detail/:id',
              name: 'medicine-detail',
              builder: (context, state) => MedicineDetailScreen(
                medicineId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/expiry-warning',
          name: 'expiry-warning',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ExpiryWarningScreen(),
          ),
        ),
        GoRoute(
          path: '/prediction',
          name: 'prediction',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PredictionScreen(),
          ),
        ),
        GoRoute(
          path: '/sync',
          name: 'sync',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SyncScreen(),
          ),
        ),
      ],
    ),
    // Rute fullscreen di luar shell (tanpa bottom navigation)
    GoRoute(
      path: '/add-medicine',
      name: 'add-medicine',
      builder: (context, state) => const AddMedicineScreen(),
    ),
  ],
);

/// Shell utama dengan bottom navigation bar.
///
/// Menggunakan pola Hybrid 4+1: 4 tab utama + 1 "Menu Lain"
/// yang membuka bottom sheet untuk akses Sinkronisasi, Prediksi, dll.
class AppShell extends StatelessWidget {
  /// Widget child yang ditampilkan di body (dari ShellRoute).
  final Widget child;

  const AppShell({super.key, required this.child});

  /// Menentukan indeks tab aktif berdasarkan lokasi rute saat ini.
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/inventory')) return 1;
    if (location.startsWith('/expiry-warning')) return 2;
    if (location.startsWith('/prediction')) return 3;
    if (location.startsWith('/sync')) return 4;
    return 0;
  }

  /// Navigasi ke rute berdasarkan indeks tab yang dipilih.
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/inventory');
      case 2:
        context.go('/expiry-warning');
      case 3:
        context.go('/prediction');
      case 4:
        context.go('/sync');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    return Scaffold(
      body: isTablet
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      _onItemTapped(context, index),
                  extended: width >= 800,
                  backgroundColor: Colors.white,
                  selectedIconTheme: const IconThemeData(
                    color: AppColors.deepGreen,
                    size: 28,
                  ),
                  unselectedIconTheme: IconThemeData(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    size: 24,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.deepGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('Beranda'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.medication_outlined),
                      selectedIcon: Icon(Icons.medication),
                      label: Text('Stok Obat'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.warning_amber_outlined),
                      selectedIcon: Icon(Icons.warning_amber),
                      label: Text('Peringatan'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_graph_outlined),
                      selectedIcon: Icon(Icons.auto_graph),
                      label: Text('Prediksi'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.sync_outlined),
                      selectedIcon: Icon(Icons.sync),
                      label: Text('Sinkronisasi'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: child),
              ],
            )
          : child,
      bottomNavigationBar: isTablet
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) =>
                  _onItemTapped(context, index),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              indicatorColor: AppColors.mintAccent,
              height: 72,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(
                    Icons.dashboard,
                    color: AppColors.deepGreen,
                  ),
                  label: 'Beranda',
                ),
                NavigationDestination(
                  icon: Icon(Icons.medication_outlined),
                  selectedIcon: Icon(
                    Icons.medication,
                    color: AppColors.deepGreen,
                  ),
                  label: 'Stok Obat',
                ),
                NavigationDestination(
                  icon: Icon(Icons.warning_amber_outlined),
                  selectedIcon: Icon(
                    Icons.warning_amber,
                    color: AppColors.deepGreen,
                  ),
                  label: 'Peringatan',
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_graph_outlined),
                  selectedIcon: Icon(
                    Icons.auto_graph,
                    color: AppColors.deepGreen,
                  ),
                  label: 'Prediksi',
                ),
                NavigationDestination(
                  icon: Icon(Icons.sync_outlined),
                  selectedIcon: Icon(
                    Icons.sync,
                    color: AppColors.deepGreen,
                  ),
                  label: 'Sinkronisasi',
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-medicine'),
        backgroundColor: AppColors.deepGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_box, size: 24),
        label: const Text(
          'Tambah Obat',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
