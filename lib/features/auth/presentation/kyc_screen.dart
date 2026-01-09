
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/sevice/image_picker_service.dart';
import '../../kyc/bloc/kyc_bloc.dart';
import '../../kyc/bloc/kyc_event.dart';
import '../../kyc/bloc/kyc_state.dart';
import '../../kyc/repository/kyc_repository.dart';
import 'investment_slab_screen.dart';


class KycVerificationScreen extends StatelessWidget {
  final KycFlowMode mode;

  const KycVerificationScreen({
    super.key,
    this.mode = KycFlowMode.optional,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KycBloc(
        imagePickerService: ImagePickerService(),
        kycRepository: KycRepository(),
      ),
      child: KycVerificationView(mode: mode),
    );
  }
}

class KycVerificationView extends StatelessWidget {
  final KycFlowMode mode;

  const KycVerificationView({
    super.key,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KycBloc, KycState>(
      listener: (context, state) {
        if (state.status == KycStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.status == KycStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const InvestmentSlabScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => mode != KycFlowMode.mandatory,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFB),
            appBar: _buildAppBar(context),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildProgressIndicator(),
                    const SizedBox(height: 24),
                    _buildTitle(),
                    const SizedBox(height: 8),
                    _buildSubtitle(),
                    const SizedBox(height: 48),
                    _buildIdPreview(context, state),
                    const SizedBox(height: 32),
                    _buildInfoCard(),
                    const SizedBox(height: 32),
                    _buildUploadSelector(context, state),
                    const SizedBox(height: 32),
                    _buildContinueButton(context, state),
                    const SizedBox(height: 16),
                    _buildSecurityBadge(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: mode == KycFlowMode.mandatory
          ? null
          : IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (mode == KycFlowMode.optional)
          TextButton(
            onPressed: () {
              context.read<KycBloc>().add(const SkipKyc());
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color:  AppColors.primary,
              ),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
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
            color: index == 1 ? AppColors.primary : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [ AppColors.primary,  AppColors.primary],
      ).createShader(bounds),
      child: const Text(
        'KYC Verification',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Upload a government-issued ID\nto complete verification',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildIdPreview(BuildContext context, KycState state) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
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
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: state.selectedImage != null
                ? ClipOval(
              child: Image.file(
                state.selectedImage!,
                fit: BoxFit.cover,
              ),
            )
                : const Center(
              child: Icon(
                Icons.badge_outlined,
                size: 64,
                color:  AppColors.primary,
              ),
            ),
          ),
          if (state.selectedImage != null)
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  context.read<KycBloc>().add(const RemoveImage());
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          if (state.status == KycStatus.loading)
            const CircularProgressIndicator(
              color:  AppColors.primary,
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
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.info_outline,
              color:  AppColors.primary,
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

  Widget _buildUploadSelector(BuildContext context, KycState state) {
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
                onTap: state.status == KycStatus.loading
                    ? null
                    : () {
                  context.read<KycBloc>().add(const PickImageFromCamera());
                },
              ),
              _UploadAction(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                onTap: state.status == KycStatus.loading
                    ? null
                    : () {
                  context.read<KycBloc>().add(const PickImageFromGallery());
                },
              ),
              _UploadAction(
                icon: Icons.upload_file_outlined,
                label: 'Files',
                onTap: state.status == KycStatus.loading
                    ? null
                    : () {
                  context.read<KycBloc>().add(const PickImageFromFiles());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, KycState state) {
    // Auto-submit when image is selected
    if (state.selectedImage != null && state.status == KycStatus.imageSelected) {
      // Automatically trigger upload after image selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<KycBloc>().add(const SubmitKyc());
      });
    }

    final isEnabled = state.selectedImage != null && state.status != KycStatus.uploading;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isEnabled
            ? const LinearGradient(
          colors: [ AppColors.primary,  AppColors.primary],
        )
            : LinearGradient(
          colors: [Colors.grey.shade300, Colors.grey.shade300],
        ),
        boxShadow: isEnabled
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>InvestmentSlabScreen()));},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: state.status == KycStatus.uploading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Row(
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
}

class _UploadAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _UploadAction({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1.0,
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
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: AppColors.primary,
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
      ),
    );
  }
}

enum KycFlowMode { mandatory, optional }

