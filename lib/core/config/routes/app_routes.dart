import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speedforce_ev/features/auth/presentation/expected_roi_screen.dart';
import 'package:speedforce_ev/features/auth/presentation/otp_verification_screen.dart';

import '../../../features/auth/presentation/investment_slab_screen.dart';
import '../../../features/auth/presentation/kyc_screen.dart';
import '../../../features/auth/presentation/registration_screen.dart';
import '../../../features/dashboard/dashboard_screen.dart';
import '../../../features/splash_screen.dart';


class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String registration = '/registration';
  static const String otp = '/otp';
  static const String kyc = '/kyc';
  static const String investmentSlab = '/investment-slab';
  static const String roi = '/roi';
  static const String dashboard = '/dashboard';

  // Router Configuration
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: registration,
        name: registration,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: otp,
        name: otp,
        builder: (context, state) {
          final phone = state.extra as String?;
          return const OtpVerificationScreen(phoneNumber:'');
        },
      ),
      GoRoute(
        path: kyc,
        name: kyc,
        builder: (context, state) => const KycVerificationScreen(),
      ),
      GoRoute(
        path: investmentSlab,
        name: investmentSlab,
        builder: (context, state) => const InvestmentSlabScreen(),
      ),
      GoRoute(
        path: roi,
        name: roi,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return const ExpectedRoiScreen(
            // slabAmount: data?['amount'] ?? 0.0,
            // expectedRoi: data?['roi'] ?? 0.0,
            // duration: data?['duration'] ?? 12,
          );
        },
      ),
      GoRoute(
        path: dashboard,
        name: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );

  // Navigation Helper Methods
  static void toRegistration(BuildContext context) {
    context.go(registration);
  }

  static void toOtp(BuildContext context, String phone) {
    context.go(otp, extra: phone);
  }

  static void toKyc(BuildContext context) {
    context.go(kyc);
  }

  static void toInvestmentSlab(BuildContext context) {
    context.go(investmentSlab);
  }

  static void toRoi(BuildContext context, {
    required double amount,
    required double roi,
    required int duration,
  }) {
    context.go(
      AppRoutes.roi,
      extra: {
        'amount': amount,
        'roi': roi,
        'duration': duration,
      },
    );
  }

  static void toDashboard(BuildContext context) {
    context.go(dashboard);
  }

  static void back(BuildContext context) {
    context.pop();
  }
}

// Usage Examples:
/*
// Navigate to screen
AppRoutes.toRegistration(context);

// Navigate with data
AppRoutes.toOtp(context, '+919876543210');

AppRoutes.toRoi(
  context,
  amount: 50000,
  roi: 12,
  duration: 12,
);

// Go back
AppRoutes.back(context);
*/