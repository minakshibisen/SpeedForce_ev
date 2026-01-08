import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/dashboard/home_screen.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';
import '../../../core/sevice/user_service.dart';
import 'investment_slab_screen.dart';

import '../../dashboard/dashboard_screen/dashboard_screen.dart';
enum KycFlowMode {
  mandatory,
  optional,
}
class KycVerificationScreen extends StatefulWidget {
  final KycFlowMode mode;

  const KycVerificationScreen({
    super.key,
    this.mode = KycFlowMode.optional,
  });

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ STEP 2: Add Skip functionality
  void _onSkip() async {
    await UserService.onKycSkipped();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }
  // ✅ STEP 3: Add Continue functionality
  void _onContinue() async {
    // Mark KYC as complete
    await UserService.completeKYC();

    // Navigate to Slab Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const InvestmentSlabScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return widget.mode != KycFlowMode.mandatory;
        },
     child: Scaffold(
       backgroundColor: const Color(0xFFF8FAFB),
       // ✅ STEP 4: Add AppBar with Skip button
       appBar: _buildAppBar(),
       body: SafeArea(
         child: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 24),
             child: FadeTransition(
               opacity: _fadeAnimation,
               child: SlideTransition(
                 position: _slideAnimation,
                 child: Column(
                   children: [
                     SizedBox(height: AppDimensions.spacingXLarge(context)),

                     // Progress Indicator
                     _buildProgressIndicator(),

                     SizedBox(height: AppDimensions.spacingLarge(context)),

                     // Title with gradient
                     ShaderMask(
                       shaderCallback: (bounds) => const LinearGradient(
                         colors: [Color(0xFF6FBF44), Color(0xFF5BA437)],
                       ).createShader(bounds),
                       child: Text(
                         'KYC Verification',
                         style: AppTextStyles.heading3(context).copyWith(
                           fontSize: 28,
                           fontWeight: FontWeight.bold,
                           color: Colors.white,
                         ),
                         textAlign: TextAlign.center,
                       ),
                     ),

                     SizedBox(height: AppDimensions.spacingSmall(context)),

                     Text(
                       'Upload a government-issued ID\nto complete verification',
                       style: AppTextStyles.bodyMedium(context).copyWith(
                         color: AppColors.textSecondary,
                         height: 1.5,
                       ),
                       textAlign: TextAlign.center,
                     ),

                     SizedBox(
                         height: AppDimensions.spacingXLarge(context) * 1.5),

                     // Enhanced ID Preview with animation
                     _buildIdPreview(),

                     const SizedBox(height: 32),

                     // Info Card
                     _buildInfoCard(),

                     const SizedBox(height: 32),

                     // Upload Actions with enhanced design
                     _UploadSelector(),

                     const SizedBox(height: 32),

                     // ✅ STEP 5: Updated Continue Button
                     _buildContinueButton(context),

                     const SizedBox(height: 16),

                     // Security Badge
                     _buildSecurityBadge(),

                     const SizedBox(height: 24),
                   ],
                 ),
               ),
             ),
           ),
         ),
       ),
     ));
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == 1 ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
            index == 1 ? const Color(0xFF6FBF44) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildIdPreview() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6FBF44).withOpacity(0.15),
            const Color(0xFF6FBF44).withOpacity(0.05),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6FBF44).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6FBF44).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.badge_outlined,
                size: 64,
                color: Color(0xFF6FBF44),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6FBF44),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6FBF44).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Add Photo',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
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
              'Accepted: Aadhaar, PAN, Passport, Driving License',
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

  // ✅ STEP 6: Updated Continue Button with KYC completion
  Widget _buildContinueButton(BuildContext context) {
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
        onPressed: _onContinue, // ✅ Updated to call _onContinue
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
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
          'Your data is secured with 256-bit encryption',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: widget.mode == KycFlowMode.mandatory
          ? null
          : IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (widget.mode == KycFlowMode.optional)
          TextButton(
            onPressed: _onSkip,
            child: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6FBF44),
              ),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

}

class _UploadSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Method',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _UploadAction(
                icon: Icons.camera_alt_outlined,
                label: 'Camera',
                onTap: () {},
              ),
              _UploadAction(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                onTap: () {},
              ),
              _UploadAction(
                icon: Icons.upload_file_outlined,
                label: 'Files',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UploadAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _UploadAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6FBF44).withOpacity(0.1),
                    const Color(0xFF6FBF44).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF6FBF44).withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                size: 26,
                color: const Color(0xFF6FBF44),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}