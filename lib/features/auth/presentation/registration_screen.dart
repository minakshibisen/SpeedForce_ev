import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/auth/presentation/otp_verification_screen.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';
import '../../../core/sevice/user_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/social_signin_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        await UserService.completeRegistration(
          userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
          userName: _nameController.text,
          userEmail: _emailController.text,
          userPhone: _phoneController.text,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              phoneNumber: _phoneController.text,
            ),
          ),
        );
      }
    }
  }

  void _onGoogleSignIn() {
    print('Google Sign In clicked');
  }

  void _onFacebookSignIn() {
    print('Facebook Sign In clicked');
  }

  void _onAppleSignIn() {
    print('Apple Sign In clicked');
  }

  void _onLoginTap() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AppDimensions.responsive(
                      context,
                      mobile: double.infinity,
                      tablet: 600,
                      desktop: 500,
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Logo Section
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F9FF),
                                    // Light blue background
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFBAE6FD),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.electric_bike_rounded,
                                    size: AppDimensions.responsive(
                                      context,
                                      mobile: 56,
                                      tablet: 64,
                                      desktop: 72,
                                    ),
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Title
                        Text(
                          'Create Account',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827), // Dark gray
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'Join us to start your EV investment journey',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Name Field
                        CustomTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          prefixIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: AppDimensions.spacingMedium(context)),

                        // Phone Field
                        PhoneTextField(
                          controller: _phoneController,
                        ),

                        SizedBox(height: AppDimensions.spacingMedium(context)),

                        // Email Field
                        EmailTextField(
                          controller: _emailController,
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Create Account Button
                        CustomButton(
                          text: 'Create Account',
                          onPressed: _onRegister,
                          isLoading: _isLoading,
                          height: AppDimensions.buttonHeightL,
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Divider with "OR"
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Social Sign In Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SocialSignInButton(
                                provider: SocialProvider.google,
                                onPressed: () {}),
                            SocialSignInButton(
                                provider: SocialProvider.facebook,
                                onPressed: () {}),
                            SocialSignInButton(
                                provider: SocialProvider.apple,
                                onPressed: () {}),
                          ],
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            TextButton(
                              onPressed: _onLoginTap,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }
}
