import 'package:flutter/cupertino.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_dimensions.dart';
import '../../../../core/config/theme/text_styles.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        SizedBox(height: AppDimensions.paddingSmall),
        Text(
          label,
          style: AppTextStyles.caption(context),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.paddingExtraSmall),
        Text(
          value,
          style: AppTextStyles.bodyLarge(context).copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}