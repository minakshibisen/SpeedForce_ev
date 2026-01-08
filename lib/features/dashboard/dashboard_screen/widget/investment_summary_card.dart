import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/dashboard/dashboard_screen/widget/stat_item.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_dimensions.dart';
import '../../../../core/config/theme/text_styles.dart';
import '../dashboard_screen.dart';

class InvestmentSummaryCard extends StatelessWidget {
  final double investmentValue;
  final double monthlyRent;
  final String rentPaid;
  final bool showInvestMore;
  final VoidCallback onViewDetails;
  final VoidCallback onShare;
  final VoidCallback? onInvestMore;

  const InvestmentSummaryCard({
    super.key,
    required this.investmentValue,
    required this.monthlyRent,
    required this.rentPaid,
    this.showInvestMore = false,
    required this.onViewDetails,
    required this.onShare,
    this.onInvestMore,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(
            AppDimensions.responsive(context, mobile: 24, tablet: 28, desktop: 32),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context),
              SizedBox(height: AppDimensions.paddingSmall),
              _buildAmount(context),
              SizedBox(height: AppDimensions.paddingMedium),
              _buildStats(context),
              SizedBox(height: AppDimensions.paddingSmall),
              _buildActions(context),
              if (showInvestMore) ...[
                SizedBox(height: AppDimensions.paddingSmall),
                _buildInvestMoreButton(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Investment Value',
        style: AppTextStyles.bodySmall(context).copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAmount(BuildContext context) {
    return Text(
      '₹${_formatCurrency(investmentValue)}',
      style: AppTextStyles.numberLarge(context),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: StatItem(
              icon: Icons.calendar_today_outlined,
              label: 'Monthly Rent',
              value: '₹${_formatCurrency(monthlyRent)}',
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: AppColors.border,
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
          ),
          Expanded(
            child: StatItem(
              icon: Icons.check_circle_outline,
              label: 'Rent Paid',
              value: rentPaid,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: onViewDetails,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'View Details',
              style: AppTextStyles.button(context).copyWith(fontSize: 15),
            ),
          ),
        ),
        SizedBox(width: AppDimensions.paddingSmall),
        OutlinedButton(
          onPressed: onShare,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            side: BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Icon(
            Icons.share_outlined,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInvestMoreButton(BuildContext context) {
    return OutlinedButton(
      onPressed: onInvestMore,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: AppColors.primary),
          SizedBox(width: AppDimensions.paddingSmall),
          Text(
            'Invest More',
            style: AppTextStyles.button(context).copyWith(
              fontSize: 15,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }
}
