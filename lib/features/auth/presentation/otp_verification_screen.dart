import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/auth/presentation/kyc_screen.dart';
import 'package:speedforce_ev/features/dashboard/home_screen.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';
import '../../../core/sevice/user_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_pin_input.dart';

import '../../dashboard/dashboard_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<CustomPinInputState> _pinKey = GlobalKey();
  int _resendTimer = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isVerifying = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();
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

  void _startTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  void _onOtpCompleted(String otp) async {
    setState(() => _isVerifying = true);

    // ✅ OTP complete
    await UserService.completeOTP();

    // 🔥 MOST IMPORTANT: mobile ke base par user state set
    await UserService.loginWithMobile(widget.phoneNumber);

    final userState = await UserService.getUserState();

    setState(() => _isVerifying = false);

    if (userState.hasCompletedKYC) {
      // 🟢 Investor → Direct Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // 🔴 New User → KYC mandatory
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const KycVerificationScreen()),
      );
    }
  }

  // ✅ STEP 2: Add navigation to KYC
  void _navigateToKyc() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const KycVerificationScreen(),
      ),
    );
  }


  void _onResend() {
    if (_canResend) {
      _pinKey.currentState?.clear();
      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              const Text('OTP sent successfully'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // ✅ STEP 4: Add Skip button in AppBar

      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingLarge(context)),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: AppDimensions.spacingLarge(context)),

                    _buildAnimatedIcon(),

                    SizedBox(height: AppDimensions.spacingXLarge(context)),

                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF6FBF44), Color(0xFF5BA437)],
                      ).createShader(bounds),
                      child: Text(
                        'Verify Your Phone No.',
                        style: AppTextStyles.heading3(context).copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: AppDimensions.spacingSmall(context)),

                    _buildSubtitle(),

                    SizedBox(height: AppDimensions.spacingXLarge(context)),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomPinInput(
                        key: _pinKey,
                        length: 6,
                        onCompleted: _onOtpCompleted,
                        fieldWidth: AppDimensions.responsive(
                          context,
                          mobile: 48,
                          tablet: 56,
                          desktop: 64,
                        ),
                        fieldHeight: AppDimensions.responsive(
                          context,
                          mobile: 56,
                          tablet: 64,
                          desktop: 72,
                        ),
                      ),
                    ),

                    SizedBox(height: AppDimensions.spacingLarge(context)),

                    _buildResendSection(),

                    SizedBox(height: AppDimensions.spacingMedium(context)),

                    _buildInfoCard(),

                    SizedBox(height: AppDimensions.spacingXLarge(context)),

                    // ✅ STEP 5: Updated Verify Button
                    _buildVerifyButton(),

                    SizedBox(height: AppDimensions.spacingMedium(context)),

                    _buildSecurityBadge(),

                    SizedBox(height: AppDimensions.spacingMedium(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6FBF44).withOpacity(0.2),
                  const Color(0xFF6FBF44).withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6FBF44).withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                size: 56,
                color: Color(0xFF6FBF44),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
          children: [
            const TextSpan(
              text: 'To verify your account, Enter the 6 digit OTP code that we sent to your mobile number\n',
            ),
            TextSpan(
              text: '+91 ${widget.phoneNumber}',
              style: const TextStyle(
                color: Color(0xFF6FBF44),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _canResend ? Icons.refresh : Icons.access_time,
            size: 18,
            color: _canResend ? const Color(0xFF6FBF44) : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          if (_canResend)
            GestureDetector(
              onTap: _onResend,
              child: Text(
                'Resend OTP',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: const Color(0xFF6FBF44),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFF6FBF44),
                ),
              ),
            )
          else
            Text(
              'Resend OTP in ${_formatTime(_resendTimer)}',
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6FBF44).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6FBF44).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Color(0xFF6FBF44),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Please check your SMS inbox for the verification code',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ STEP 6: Updated Verify Button with OTP completion
  Widget _buildVerifyButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6FBF44), Color(0xFF5BA437)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6FBF44).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isVerifying
            ? null
            : () async {
          setState(() => _isVerifying = true);

          await UserService.completeOTP();
          await UserService.loginWithMobile(widget.phoneNumber);

          final userState = await UserService.getUserState();

          setState(() => _isVerifying = false);

          if (userState.hasCompletedKYC) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const KycVerificationScreen(),
              ),
            );
          }
        },

        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isVerifying
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verify & Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          'Your information is secured and encrypted',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}