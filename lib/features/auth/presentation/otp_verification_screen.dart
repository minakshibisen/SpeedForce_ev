import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/auth/presentation/kyc_screen.dart';
import '../../../core/config/routes/app_routes.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_pin_input.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final GlobalKey<CustomPinInputState> _pinKey = GlobalKey();
  int _resendTimer = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
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

  void _onOtpCompleted(String otp) {
    setState(() => _isVerifying = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isVerifying = false);
        AppRoutes.toKyc(context);
      }
    });
  }

  void _onResend() {
    if (_canResend) {
      _pinKey.currentState?.clear();
      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP sent successfully'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingLarge(context)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Icon
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
            Icons.mark_email_read_outlined,
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
            
                SizedBox(height: AppDimensions.spacingXLarge(context)),
            
                // Title
                Text(
                  'Verify Your Phone No.',
                  style: AppTextStyles.heading3(context),
                  textAlign: TextAlign.center,
                ),
            
                SizedBox(height: AppDimensions.spacingSmall(context)),
            
                // Subtitle
                Text(
                  'To verify your account, Enter the 6 digit OTP code that we sent to your mobile number \n+91 ${widget.phoneNumber}',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
            
                SizedBox(height: AppDimensions.spacingXLarge(context)),
            
                // OTP Input
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
            
                // Timer and Resend Text
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Didn't receive the code? ",
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (_canResend)
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: _onResend,
                            child: Text(
                              'Resend',
                              style: AppTextStyles.bodyMedium(context).copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )
                      else
                        TextSpan(
                          text: 'Resend in ${_formatTime(_resendTimer)}',
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppDimensions.spacingXLarge(context)),

                CustomButton(
                  text: 'Verify',
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>KycVerificationScreen()));
                  },
                  isLoading: _isVerifying,
                  height: AppDimensions.buttonHeightL,
                ),
            
                SizedBox(height: AppDimensions.spacingMedium(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

