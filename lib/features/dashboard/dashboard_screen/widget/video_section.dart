import 'package:flutter/cupertino.dart';
import 'package:speedforce_ev/features/dashboard/dashboard_screen/widget/video_card.dart';

import '../../../../core/config/theme/app_dimensions.dart';
import '../../../../core/widgets/section_header.dart';
import '../dashboard_screen.dart';

class VideoSection extends StatelessWidget {
  const VideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Videos',
          onSeeAll: () {},
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = AppDimensions.responsive(
              context,
              mobile: 240.0,
              tablet: 280.0,
              desktop: 320.0,
            );

            return SizedBox(
              height: AppDimensions.responsive(
                context,
                mobile: 160.0,
                tablet: 180.0,
                desktop: 200.0,
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => SizedBox(width: AppDimensions.paddingSmall),
                itemBuilder: (context, index) {
                  return VideoCard(width: cardWidth);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
