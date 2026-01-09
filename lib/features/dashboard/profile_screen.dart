import 'package:flutter/material.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Personal Info'),
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
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          children: [
            ProfileAvatarSection(),
            SizedBox(height: AppDimensions.paddingLarge),
            ProfileInputField(
              label: 'Full Name',
              hint: 'User Name',
            ),
            ProfileInputField(
              label: 'Date of Birth',
              hint: '00/00/0000',
              suffixIcon: Icons.calendar_today_outlined,
            ),
            ProfileInputField(
              label: 'Email',
              hint: 'user.name@gmail.com',
              prefixIcon: Icons.email_outlined,
            ),
            ProfileInputField(
              label: 'Phone Number',
              hint: '+91 00000 00000',
              prefixIcon: Icons.phone_outlined,
            ),
            ProfileInputField(
              label: 'Nominee',
              hint: 'Nominee Name',
              prefixIcon: Icons.person_outline,
            ),
            SizedBox(height: AppDimensions.paddingLarge),
            PaymentMethodSection(),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Personal Info',
        style: AppTextStyles.heading4(context),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.textSecondary,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.paddingSmall),
        TextButton(
          onPressed: () {},
          child: Text(
            'Change Photo',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ============= PROFILE INPUT FIELD =============
class ProfileInputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const ProfileInputField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.inputLabel(context),
          ),
          SizedBox(height: AppDimensions.paddingExtraSmall),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            style: AppTextStyles.input(context),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.input(context).copyWith(
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                prefixIcon,
                color: AppColors.textSecondary,
                size: 20,
              )
                  : null,
              suffixIcon: suffixIcon != null
                  ? Icon(
                suffixIcon,
                color: AppColors.textSecondary,
                size: 20,
              )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: AppDimensions.paddingMedium,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============= PAYMENT METHOD SECTION =============
class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTextStyles.heading4(context),
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        const BankAccountTile(
          bankName: 'HDFC Bank',
          accountNumber: '•••• 1234',
          isPrimary: true,
        ),
        const BankAccountTile(
          bankName: 'State Bank of India',
          accountNumber: '•••• 4321',
          isPrimary: false,
        ),
        SizedBox(height: AppDimensions.paddingSmall),
        TextButton.icon(
          onPressed: () {},
          icon: Icon(
            Icons.add_circle_outline,
            color: AppColors.primary,
          ),
          label: Text(
            'Add New Bank',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                context,
                'Once bank details are updated, further changes will be allowed after verification.',
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              _buildInfoRow(
                context,
                'Only one primary bank account is allowed.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textSecondary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppDimensions.paddingSmall),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption(context),
          ),
        ),
      ],
    );
  }
}

// ============= BANK ACCOUNT TILE =============
class BankAccountTile extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final bool isPrimary;

  const BankAccountTile({
    super.key,
    required this.bankName,
    required this.accountNumber,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: isPrimary ? AppColors.primary.withOpacity(0.3) : AppColors.border,
          width: isPrimary ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(
              Icons.account_balance_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: AppTextStyles.bodyLarge(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppDimensions.paddingExtraSmall),
                Text(
                  accountNumber,
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),
          if (isPrimary)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSmall,
                vertical: AppDimensions.paddingExtraSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Text(
                'Primary',
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============= SAVE BUTTON (Optional - Add at bottom) =============
class SaveProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveProfileButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: Size(double.infinity, AppDimensions.buttonHeightL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
        child: Text(
          'Save Changes',
          style: AppTextStyles.button(context),
        ),
      ),
    );
  }
}