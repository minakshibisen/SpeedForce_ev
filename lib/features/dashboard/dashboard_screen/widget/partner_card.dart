import 'package:flutter/material.dart';

/// Reusable Partner Card Widget
///
/// Usage:
/// ```dart
/// PartnerCard(
///   logoPath: 'assets/images/partner_logo.png',
///   width: 160,
///   height: 90,
/// )
/// ```
class PartnerCard extends StatelessWidget {
  final String logoPath;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final VoidCallback? onTap;

  const PartnerCard({
    super.key,
    required this.logoPath,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 160,
        height: height ?? 90,
        margin: margin ?? const EdgeInsets.only(right: 12),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          border: Border.all(
            color: borderColor ?? const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Image.asset(
          logoPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.business,
                color: Colors.grey.shade400,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Partners Section using the reusable PartnerCard
///
/// This is a complete implementation showing how to use PartnerCard
class PartnersSection extends StatelessWidget {
  final List<String> partnerLogos;
  final String title;
  final VoidCallback? onViewAll;
  final Color? primaryColor;
  final double cardWidth;
  final double cardHeight;

  const PartnersSection({
    super.key,
    required this.partnerLogos,
    this.title = 'Our Partners',
    this.onViewAll,
    this.primaryColor,
    this.cardWidth = 160,
    this.cardHeight = 90,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            if (onViewAll != null)
              TextButton.icon(
                onPressed: onViewAll,
                icon: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                label: const Icon(Icons.arrow_forward_ios, size: 14),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor ?? const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: partnerLogos.length,
            itemBuilder: (context, index) {
              return PartnerCard(
                logoPath: partnerLogos[index],
                width: cardWidth,
                height: cardHeight,
                onTap: () {
                  // Handle partner card tap
                  debugPrint('Tapped on partner: ${partnerLogos[index]}');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Example Usage in Dashboard
///
/// ```dart
/// // Simple usage with default styling
/// PartnersSection(
///   partnerLogos: [
///     'assets/images/joy_img.png',
///     'assets/images/wardwizard_logo.png',
///     'assets/images/jiothings_logo.png',
///   ],
/// )
///
/// // Custom usage with options
/// PartnersSection(
///   partnerLogos: partnerList,
///   title: 'Trusted Partners',
///   primaryColor: AppColors.primary,
///   cardWidth: 180,
///   cardHeight: 100,
///   onViewAll: () {
///     Navigator.push(context, MaterialPageRoute(
///       builder: (_) => AllPartnersScreen(),
///     ));
///   },
/// )
///
/// // Use PartnerCard individually anywhere
/// PartnerCard(
///   logoPath: 'assets/images/partner.png',
///   width: 200,
///   height: 120,
///   backgroundColor: Colors.grey.shade50,
///   borderColor: Colors.blue,
///   borderRadius: 20,
///   onTap: () => print('Partner tapped'),
/// )
/// ```