import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/auth_providers.dart';
import '../../presentation/providers/city_provider.dart';
import '../../presentation/screens/auth/city_selection_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/otp_screen.dart';
import '../../presentation/screens/auth/splash_screen.dart';
import '../../presentation/screens/chat/trip_chat_screen.dart';
import '../../presentation/screens/home/passenger_home_screen.dart';
import '../../presentation/screens/payment/payment_rating_screen.dart';
import '../../presentation/screens/ride/driver_matching_screen.dart';
import '../../presentation/screens/ride/ride_selection_screen.dart';
import 'go_router_refresh_stream.dart';

final passengerRouterProvider = Provider<GoRouter>((ref) {
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
        path: '/city',
        builder: (context, state) => const CitySelectionScreen(),
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
        builder: (context, state) => const PassengerHomeScreen(),
      ),
      GoRoute(
        path: '/chat/:tripId',
        builder: (context, state) {
          final tripId = state.pathParameters['tripId'] ?? '';
          return TripChatScreen(tripId: tripId);
        },
      ),
      GoRoute(
        path: '/ride',
        builder: (context, state) => const RideSelectionScreen(),
      ),
      GoRoute(
        path: '/matching',
        builder: (context, state) => const DriverMatchingScreen(),
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) => const PaymentRatingScreen(),
      ),
    ],
    redirect: (context, state) {
      final city = ref.read(selectedCityProvider);
      final user = auth.currentUser;
      final location = state.matchedLocation;

      final isAuthed = user != null;
      final hasCity = city != null;

      if (location == '/splash') {
        if (!hasCity) return '/city';
        if (!isAuthed) return '/login';
        return '/home';
      }

      if (!hasCity && location != '/city') return '/city';
      if (hasCity && !isAuthed && location == '/home') return '/login';
      if (hasCity && isAuthed && (location == '/login' || location == '/otp')) {
        return '/home';
      }

      return null;
    },
  );
});

