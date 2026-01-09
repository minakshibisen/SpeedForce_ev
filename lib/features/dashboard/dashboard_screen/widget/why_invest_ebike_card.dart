import 'package:flutter/material.dart';

class WhyInvestEBikeCard extends StatelessWidget {
  const WhyInvestEBikeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final benefits = [
      {
        'icon': Icons.trending_up_rounded,
        'title': 'Growing Market',
        'description': '₹40B+ global market with 15% annual growth',
        'color': Colors.green,
      },
      {
        'icon': Icons.eco_rounded,
        'title': 'Sustainable Future',
        'description': 'Green transportation revolution',
        'color': Colors.teal,
      },
      {
        'icon': Icons.auto_awesome_rounded,
        'title': 'Low Maintenance',
        'description': 'High demand rental model',
        'color': Colors.orange,
      },
      {
        'icon': Icons.policy_rounded,
        'title': 'Government Support',
        'description': 'Incentives & mobility initiatives',
        'color': Colors.blue,
      },
      {
        'icon': Icons.verified_rounded,
        'title': 'Proven Returns',
        'description': '18% average annual ROI',
        'color': Colors.purple,
      },
      {
        'icon': Icons.shield_rounded,
        'title': 'Fully Insured',
        'description': 'Comprehensive fleet coverage',
        'color': Colors.indigo,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.tertiaryContainer.withOpacity(0.6),
            colorScheme.primaryContainer.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.tertiary.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
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
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 10 : 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.tertiary,
                            colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.electric_bike_rounded,
                        color: colorScheme.onTertiary,
                        size: isMobile ? 22 : 28,
                      ),
                    ),
                    SizedBox(width: isMobile ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why Invest in E-Bikes?',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              fontSize: isMobile ? 18 : 22,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Building sustainable future',
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
                SizedBox(height: isMobile ? 16 : 20),

                // Benefits List - Compact for mobile
                ...benefits.map((benefit) => Padding(
                  padding: EdgeInsets.only(bottom: isMobile ? 12 : 14),
                  child: _buildBenefitItem(
                    context,
                    benefit['icon'] as IconData,
                    benefit['title'] as String,
                    benefit['description'] as String,
                    benefit['color'] as Color,
                    isMobile,
                  ),
                )),

                SizedBox(height: isMobile ? 8 : 12),

                // Stats Section - Grid layout for mobile
                Container(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.12),
                        colorScheme.secondary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: colorScheme.primary,
                            size: isMobile ? 22 : 28,
                          ),
                          SizedBox(width: isMobile ? 8 : 12),
                          Text(
                            'Our Impact',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              fontSize: isMobile ? 16 : 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              context,
                              '50M+',
                              'Rides\nCompleted',
                              Icons.two_wheeler_rounded,
                              isMobile,
                            ),
                          ),
                          SizedBox(width: isMobile ? 10 : 16),
                          Expanded(
                            child: _buildStatItem(
                              context,
                              '15K tons',
                              'CO₂\nPrevented',
                              Icons.co2_rounded,
                              isMobile,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 24),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: isMobile ? 50 : 56,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline_rounded),
                    label: Text(
                      'Learn More',
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.tertiary,
                      foregroundColor: colorScheme.onTertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
      BuildContext context,
      IconData icon,
      String title,
      String description,
      Color color,
      bool isMobile,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 7 : 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: isMobile ? 18 : 20,
          ),
        ),
        SizedBox(width: isMobile ? 10 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontSize: isMobile ? 14 : 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  height: 1.3,
                  fontSize: isMobile ? 12 : 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String value,
      String label,
      IconData icon,
      bool isMobile,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: isMobile ? 20 : 24,
          ),
          SizedBox(height: isMobile ? 6 : 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontSize: isMobile ? 18 : 22,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 2 : 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: isMobile ? 10 : 11,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}