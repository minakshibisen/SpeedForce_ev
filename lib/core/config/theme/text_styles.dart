import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

class AppTextStyles {

  static TextStyle heading1(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 32, tablet: 36, desktop: 40),
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle heading2(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 28, tablet: 30, desktop: 32),
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle heading3(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 24, tablet: 26, desktop: 28),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle heading4(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 20, tablet: 22, desktop: 24),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ============ Body Text ============

  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 16, tablet: 17, desktop: 18),
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 14, tablet: 15, desktop: 16),
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 12, tablet: 13, desktop: 14),
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ============ Button Text ============

  static TextStyle button(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 16, tablet: 17, desktop: 18),
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle buttonSmall(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 14, tablet: 15, desktop: 16),
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // ============ Special Text ============

  static TextStyle caption(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 12, tablet: 13, desktop: 14),
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle overline(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 10, tablet: 11, desktop: 12),
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
  ).copyWith(textBaseline: TextBaseline.alphabetic);

  // ============ Numbers/Stats ============

  static TextStyle numberLarge(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 32, tablet: 36, desktop: 40),
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.2,
  );

  static TextStyle numberMedium(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 24, tablet: 26, desktop: 28),
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // ============ Input Text ============

  static TextStyle input(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 16, tablet: 17, desktop: 18),
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle inputLabel(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 14, tablet: 15, desktop: 16),
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle inputError(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 12, tablet: 13, desktop: 14),
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    height: 1.4,
  );

  // ============ Link/Action Text ============

  static TextStyle link(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 14, tablet: 15, desktop: 16),
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // ============ Currency Text ============

  static TextStyle currency(BuildContext context) => GoogleFonts.inter(
    fontSize: AppDimensions.responsive(context, mobile: 24, tablet: 26, desktop: 28),
    fontWeight: FontWeight.bold,
    color: AppColors.success,
    height: 1.2,
  );

  // ============ Helper Methods ============

  // Apply color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // Apply weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  // Apply size
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}

// Usage Examples:
/*
// Headings
Text(
  'Welcome',
  style: AppTextStyles.heading1(context),
)

Text(
  'Dashboard',
  style: AppTextStyles.heading3(context),
)

// Body Text
Text(
  'Lorem ipsum dolor sit amet',
  style: AppTextStyles.bodyMedium(context),
)

// Button Text (usually auto-applied in CustomButton)
Text(
  'Continue',
  style: AppTextStyles.button(context),
)

// Numbers/Stats
Text(
  '₹50,000',
  style: AppTextStyles.currency(context),
)

Text(
  '12%',
  style: AppTextStyles.numberMedium(context),
)

// With custom color
Text(
  'Error message',
  style: AppTextStyles.withColor(
    AppTextStyles.bodyMedium(context),
    AppColors.error,
  ),
)

// Link
TextButton(
  onPressed: () {},
  child: Text(
    'Forgot Password?',
    style: AppTextStyles.link(context),
  ),
)

// Responsive text automatically adjusts based on screen size!
// Mobile: 16px
// Tablet: 17px
// Desktop: 18px
*/