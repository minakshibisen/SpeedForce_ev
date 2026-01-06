import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/auth/presentation/otp_verification_screen.dart';
import '../../../core/config/routes/app_routes.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/social_signin_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          // Navigate to OTP screen
          AppRoutes.toOtp(context, _phoneController.text);
        }
      });
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLarge(context),
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

                    // Logo or Icon
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(
                          AppDimensions.paddingMedium(context),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
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
                    ),

                    SizedBox(height: AppDimensions.spacingLarge(context)),

                    // Title
                    Text(
                      'Create Account',
                      style: AppTextStyles.heading2(context),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: AppDimensions.spacingSmall(context)),

                    // Subtitle
                    Text(
                      'Join us to start your EV investment journey',
                      style: AppTextStyles.bodyMedium(context),
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
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerificationScreen(phoneNumber: '',)));
                      },
                      isLoading: _isLoading,
                      height: AppDimensions.buttonHeightL,
                    ),

                    SizedBox(height: AppDimensions.spacingLarge(context)),

                    // Divider with "OR"
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceM,
                          ),
                          child: Text(
                            'OR',
                            style: AppTextStyles.bodySmall(context),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.border)),
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
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    );
  }
}

