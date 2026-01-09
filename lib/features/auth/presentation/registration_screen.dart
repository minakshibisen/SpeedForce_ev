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

  // Animation controllers
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

  // ✅ STEP 2: Update _onRegister method
  void _onRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        // ✅ STEP 3: Save registration data
        // Yahan par aap API se mila userId save karenge
        await UserService.completeRegistration(
          userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
          userName: _nameController.text,
          userEmail: _emailController.text,
          userPhone: _phoneController.text,
        );

        // Navigate to OTP screen
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
    // TODO: Implement Google Sign In
    print('Google Sign In clicked');
  }

  void _onFacebookSignIn() {
    // TODO: Implement Facebook Sign In
    print('Facebook Sign In clicked');
  }

  void _onAppleSignIn() {
    // TODO: Implement Apple Sign In
    print('Apple Sign In clicked');
  }

  void _onLoginTap() {
    // TODO: Navigate to login screen
    print('Login clicked');
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
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

                        // Enhanced Logo
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  padding: EdgeInsets.all(
                                    AppDimensions.paddingMedium,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withOpacity(0.2),
                                        AppColors.primary.withOpacity(0.1),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.electric_car,
                                    size: AppDimensions.responsive(
                                      context,
                                      mobile: 64,
                                      tablet: 72,
                                      desktop: 80,
                                    ),
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Title with gradient
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.primary,AppColors.primary],
                          ).createShader(bounds),
                          child: Text(
                            'Create Account',
                            style: AppTextStyles.heading2(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: AppDimensions.spacingSmall(context)),

                        // Subtitle
                        Text(
                          'Join us to start your EV investment journey',
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: AppColors.textSecondary,
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
                          onPressed: _onRegister, // ✅ Updated method
                          isLoading: _isLoading,
                          height: AppDimensions.buttonHeightL,
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Divider with "OR"
                        Row(
                          children: [
                            const Expanded(
                                child: Divider(color: AppColors.border)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spaceM,
                              ),
                              child: Text(
                                'OR',
                                style: AppTextStyles.bodySmall(context),
                              ),
                            ),
                            const Expanded(
                                child: Divider(color: AppColors.border)),
                          ],
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        // Social Sign In Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SocialSignInButton(
                              provider: SocialProvider.google,
                              onPressed: _onGoogleSignIn,
                            ),
                            SocialSignInButton(
                              provider: SocialProvider.facebook,
                              onPressed: _onFacebookSignIn,
                            ),
                            SocialSignInButton(
                              provider: SocialProvider.apple,
                              onPressed: _onAppleSignIn,
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.spacingLarge(context)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: AppTextStyles.bodyMedium(context),
                            ),
                            TextButton(
                              onPressed: _onLoginTap,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Login',
                                style: AppTextStyles.link(context),
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
}