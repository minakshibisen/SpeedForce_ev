import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_dimensions.dart';
import '../../../../core/config/theme/text_styles.dart';
import '../../../../core/widgets/section_header.dart';
import '../dashboard_screen.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final partners = [
      'Jio',
      'Wardwizard',
      'JioThings',
      'Bluebells',
      'HDFC Bank',
      'Kotak',
      'Electrik',
      'SBI',
      'Ampvolts',
    ];

    return Column(
      children: [
        SectionHeader(
          title: 'Our Partners',
          onSeeAll: () {},
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = AppDimensions.responsive(
              context,
              mobile: 3,
              tablet: 4,
              desktop: 5,
            ).toInt();

            return GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: partners.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: AppDimensions.paddingSmall,
                crossAxisSpacing: AppDimensions.paddingSmall,
                childAspectRatio: 2.1,
              ),
              itemBuilder: (context, index) {
                return PartnerCard(name: partners[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

// ============= REUSABLE: PARTNER CARD =============
class PartnerCard extends StatelessWidget {
  final String name;

  const PartnerCard({
    super.key,
    required this.name,
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
      child: Center(
        child: Text(
          name,
          style: AppTextStyles.bodySmall(context).copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}