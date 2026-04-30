import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/auth_providers.dart';
import '../../presentation/providers/driver_profile_providers.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/otp_screen.dart';
import '../../presentation/screens/auth/splash_screen.dart';
import '../../presentation/screens/home/driver_home_screen.dart';
import '../../presentation/screens/home/incoming_trip_screen.dart';
import '../../presentation/screens/registration/driver_registration_screen.dart';
import 'go_router_refresh_stream.dart';

final driverRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final authListenable = GoRouterRefreshStream(auth.authStateChanges());

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authListenable,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! OtpArgs) return const LoginScreen();
          return OtpScreen(args: extra);
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DriverHomeScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const DriverRegistrationScreen(),
      ),
      GoRoute(
        path: '/incoming',
        builder: (context, state) => const IncomingTripScreen(),
      ),
    ],
    redirect: (context, state) {
      final user = auth.currentUser;
      final isAuthed = user != null;
      final location = state.matchedLocation;
      final driverDoc = ref.read(driverProfileProvider).valueOrNull;
      final isRegistered = driverDoc != null;
      final isApproved = (driverDoc?['isApproved'] as bool?) ?? false;

      if (location == '/splash') return isAuthed ? '/home' : '/login';
      if (!isAuthed && location == '/home') return '/login';
      if (isAuthed && (location == '/login' || location == '/otp')) return '/home';
      if (isAuthed && !isRegistered && location != '/register') return '/register';
      if (isAuthed && isRegistered && !isApproved && location != '/home') return '/home';

      return null;
    },
  );
});

