import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/dashboard/admin_dashboard_screen.dart';
import '../../presentation/screens/dashboard/pricing_promo_management_screen.dart';
import '../../presentation/screens/sos/sos_panel_screen.dart';

final adminRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/pricing',
        builder: (context, state) => const PricingPromoManagementScreen(),
      ),
      GoRoute(
        path: '/sos',
        builder: (context, state) => const SosPanelScreen(),
      ),
    ],
  );
});

