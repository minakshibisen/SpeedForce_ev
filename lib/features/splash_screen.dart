import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/auth/presentation/registration_screen.dart';
import '../core/config/routes/app_routes.dart';
import '../core/config/theme/app_colors.dart';
import '../core/config/theme/app_dimensions.dart';
import '../core/widgets/custom_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize AppDimensions (IMPORTANT!)
    AppDimensions.init(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primarylightGradient, // ✅ Fix: primarylightGradient → primaryGradient
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.responsive(
            context,
            mobile: AppDimensions.spaceL,      // 24px on mobile
            tablet: AppDimensions.spaceXL * 2, // 64px on tablet
            desktop: AppDimensions.spaceXXL * 3, // 144px on desktop
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/company_logo.png',
                  height: AppDimensions.responsive(
                    context,
                    mobile: 120,
                    tablet: 150,
                    desktop: 180,
                  ),
                ),

                // Spacing
                SizedBox(
                  height: AppDimensions.responsive(
                    context,
                    mobile: AppDimensions.spaceXL,  // 32px
                    tablet: AppDimensions.spaceXXL, // 48px
                    desktop: AppDimensions.spaceXXL * 1.5, // 72px
                  ),
                ),

                // Button
                CustomButton(
                  text: "Let's Get Started",
                  icon: Icons.arrow_forward,
                  onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen(),));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

