import 'package:flutter/material.dart';
import 'package:speedforce_ev/core/config/theme/app_colors.dart';

import '../../../../core/config/theme/app_dimensions.dart';

class InvestmentCalculatorCard extends StatefulWidget {
  const InvestmentCalculatorCard({super.key});

  @override
  State<InvestmentCalculatorCard> createState() => _InvestmentCalculatorCardState();
}

class _InvestmentCalculatorCardState extends State<InvestmentCalculatorCard> {
  double _investmentAmount = 50000;
  final double _minAmount = 10000;
  final double _maxAmount = 1000000;

  Map<String, double> _calculateReturns(double amount) {
    return {
      'monthly': amount * 0.015,
      'yearly': amount * 0.18,
      'threeYear': amount * 0.65,
    };
  }

  @override
  Widget build(BuildContext context) {
    final returns = _calculateReturns(_investmentAmount);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.all(
        AppDimensions.responsive(context, mobile: 15, tablet: 28, desktop: 36),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary,width: 0.5)

      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - Compact for mobile
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 10 : 12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.calculate_rounded,
                        color: colorScheme.onPrimary,
                        size: isMobile ? 22 : 28,
                      ),
                    ),
                    SizedBox(width: isMobile ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Investment Calculator',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              fontSize: isMobile ? 18 : 22,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Calculate your returns',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: isMobile ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 20 : 28),

                // Investment Amount Display - More prominent on mobile
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 16 : 20,
                    horizontal: isMobile ? 16 : 24,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Investment Amount',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontSize: isMobile ? 11 : 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '₹${_investmentAmount.toStringAsFixed(0)}',
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            letterSpacing: -1,
                            fontSize: isMobile ? 36 : 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 20),

                // Slider - Larger touch target for mobile
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: isMobile ? 6 : 8,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: isMobile ? 12 : 14,
                      elevation: 3,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: isMobile ? 24 : 28,
                    ),
                    activeTrackColor: colorScheme.primary,
                    inactiveTrackColor: colorScheme.surfaceVariant,
                    thumbColor: colorScheme.primary,
                    overlayColor: colorScheme.primary.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: _investmentAmount,
                    min: _minAmount,
                    max: _maxAmount,
                    divisions: 99,
                    onChanged: (value) {
                      setState(() {
                        _investmentAmount = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${(_minAmount / 1000).toStringAsFixed(0)}K',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 11 : 12,
                        ),
                      ),
                      Text(
                        '₹${(_maxAmount / 1000).toStringAsFixed(0)}K',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 11 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 28),

                // Returns Cards - Stacked vertically on mobile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildReturnCard(
                      context,
                      'Monthly Returns',
                      returns['monthly']!,
                      colorScheme.tertiary,
                      isMobile,
                    ),
                    SizedBox(height: isMobile ? 10 : 12),
                    _buildReturnCard(
                      context,
                      'Yearly Returns',
                      returns['yearly']!,
                      colorScheme.secondary,
                      isMobile,
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReturnCard(
      BuildContext context,
      String label,
      double amount,
      Color accentColor,
      bool isMobile,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    fontSize: isMobile ? 20 : 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}