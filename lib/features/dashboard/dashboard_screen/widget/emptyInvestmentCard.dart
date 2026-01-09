import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_dimensions.dart';
import '../../../../core/config/theme/text_styles.dart';

class EmptyInvestmentCard extends StatelessWidget {
  final VoidCallback onInvestNow;

  const EmptyInvestmentCard({
    super.key,
    required this.onInvestNow,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(
            AppDimensions.responsive(context, mobile: 15, tablet: 28, desktop: 36),
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.surface, AppColors.surface],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
           border: Border.all(color: AppColors.primary,width: 0.5)
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              SizedBox(height: AppDimensions.paddingMedium),
              Text(
                'Start Your Investment Journey',
                style: AppTextStyles.heading3(context).copyWith(color:AppColors.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              Text(
                'Invest in sustainable EV charging\nand earn consistent returns',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              SizedBox(
                width: double.infinity,
                height: isMobile ? 50 : 56,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.rocket_launch_rounded),
                  label: Text(
                    'Start Investing',
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                ),
              ),            ],
          ),
        );
      },
    );
  }
}
