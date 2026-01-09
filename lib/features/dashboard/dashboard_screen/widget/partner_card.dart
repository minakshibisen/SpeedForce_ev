import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_dimensions.dart';
import '../../../../core/widgets/section_header.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final partnerLogos = [
      'assets/images/joy_img.png',
      'assets/images/wardwizard_logo.png',
      'assets/images/jiothings_logo.png',
      'assets/images/img.png',
      'assets/images/img_1.png',
      'assets/images/img_2.png',
      'assets/images/img.png',
      'assets/images/img_1.png',
      'assets/images/img_2.png',

    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 3 : screenWidth < 900 ? 4 : 5;

    return Column(
      children: [
        SectionHeader(
          title: 'Our Partners',
          onSeeAll: () {},
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: partnerLogos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppDimensions.paddingSmall,
            crossAxisSpacing: AppDimensions.paddingSmall,
            childAspectRatio: 2.1,
          ),
          itemBuilder: (context, index) {
            return PartnerCard(logoPath: partnerLogos[index]);
          },
        ),
      ],
    );
  }
}

// ============= REUSABLE: PARTNER CARD =============
class PartnerCard extends StatelessWidget {
  final String logoPath;

  const PartnerCard({
    super.key,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(0),
      child: Image.asset(
        logoPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback icon if image not found
          return Center(
            child: Icon(
              Icons.business,
              color: AppColors.textSecondary.withOpacity(0.3),
              size: 32,
            ),
          );
        },
      ),
    );
  }
}
