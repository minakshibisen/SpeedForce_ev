import 'package:flutter/material.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/app_dimensions.dart';

enum SocialProvider { google, facebook, apple }

class SocialSignInButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback onPressed;

  const SocialSignInButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(provider);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        width: 100,
        height: 52,
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: config.borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Image.asset(
          config.iconPath,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  _SocialButtonConfig _getConfig(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return _SocialButtonConfig(
          iconPath: 'assets/images/google.png',
          backgroundColor: Colors.white,
          borderColor: AppColors.border,
        );

      case SocialProvider.facebook:
        return _SocialButtonConfig(
          iconPath: 'assets/images/facebook.png',
          backgroundColor: Colors.white,
          borderColor: AppColors.border,
        );

      case SocialProvider.apple:
        return _SocialButtonConfig(
          iconPath: 'assets/images/apple.png',
          backgroundColor: Colors.white,
          borderColor: AppColors.border,
        );
    }
  }
}

class _SocialButtonConfig {
  final String iconPath;
  final Color backgroundColor;
  final Color borderColor;

  _SocialButtonConfig({
    required this.iconPath,
    required this.backgroundColor,
    required this.borderColor,
  });
}
