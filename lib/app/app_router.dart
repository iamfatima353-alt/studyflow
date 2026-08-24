import 'package:go_router/go_router.dart';
import '../features/auth/signup_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/auth/forgot_password_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) {
        return const OnboardingScreen();
      },
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/signup',
       builder: (context, state) => const SignupScreen(),
),
GoRoute(
  path: '/forgot-password',
  builder: (context, state) {
    return const ForgotPasswordScreen();
  },
),

    GoRoute(
      path: '/home',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ],
);