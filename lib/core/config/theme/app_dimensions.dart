import 'package:flutter/material.dart';

/// AppDimensions - Centralized responsive sizing system
class AppDimensions {
  // ============ Screen Size Variables ============
  static late double screenWidth;
  static late double screenHeight;

  /// Initialize karo har screen ke build method mein
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  // ============ Responsive Helpers ============

  /// Responsive width (based on 375px iPhone SE width)
  static double width(double size) => (screenWidth / 375) * size;

  /// Responsive height (based on 812px iPhone X height)
  static double height(double size) => (screenHeight / 812) * size;

  /// Responsive font size
  static double fontSize(double size) => (screenWidth / 375) * size;

  // ============ Spacing Constants ============
  static const double spaceXS = 4.0;   // Extra Small
  static const double spaceS = 8.0;    // Small
  static const double spaceM = 16.0;   // Medium (default)
  static const double spaceL = 24.0;   // Large
  static const double spaceXL = 32.0;  // Extra Large
  static const double spaceXXL = 48.0; // Extra Extra Large

  // ============ Padding Constants (Simple) ============
  static const double paddingExtraSmall = spaceXS;  // 4px
  static const double paddingSmall = spaceS;         // 8px
  static const double paddingMedium = spaceM;        // 16px
  static const double paddingLarge = spaceL;         // 24px
  static const double paddingExtraLarge = spaceXL;   // 32px

  // ============ Helper Methods (Responsive Spacing) ============

  /// Small spacing - responsive
  static double spacingSmall(BuildContext context) {
    return responsive(context, mobile: spaceS, tablet: 12.0, desktop: 12.0);
  }

  /// Medium spacing - responsive
  static double spacingMedium(BuildContext context) {
    return responsive(context, mobile: spaceM, tablet: 20.0, desktop: spaceL);
  }

  /// Large spacing - responsive
  static double spacingLarge(BuildContext context) {
    return responsive(context, mobile: spaceL, tablet: spaceXL, desktop: 40.0);
  }

  /// Extra large spacing - responsive
  static double spacingXLarge(BuildContext context) {
    return responsive(context, mobile: spaceXL, tablet: spaceXXL, desktop: 64.0);
  }

  // ============ Border Radius ============
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 999.0; // Fully rounded

  // ============ Button Sizes ============
  static const double buttonHeightS = 40.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // ============ Icon Sizes ============
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // ============ Pre-defined Padding (EdgeInsets) ============

  // All sides padding
  static const EdgeInsets paddingXS = EdgeInsets.all(spaceXS);
  static const EdgeInsets paddingS = EdgeInsets.all(spaceS);
  static const EdgeInsets paddingM = EdgeInsets.all(spaceM);
  static const EdgeInsets paddingL = EdgeInsets.all(spaceL);
  static const EdgeInsets paddingXL = EdgeInsets.all(spaceXL);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: spaceS);
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: spaceM);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: spaceL);

  // Vertical padding
  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: spaceS);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: spaceM);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: spaceL);

  // Default screen padding
  static const EdgeInsets screenPadding = EdgeInsets.all(spaceL);

  // ============ Device Type Detection ============

  /// Check if mobile (< 600px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Check if tablet (600-900px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  /// Check if desktop (>= 900px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  // ============ Responsive Value Helper ============

  /// Returns different values based on device type
  static T responsive<T>(
      BuildContext context, {
        required T mobile,
        T? tablet,
        T? desktop,
      }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }
}

/* ============================================
   USAGE EXAMPLES - UPDATED
   ============================================

// 1. Initialize in every screen (REQUIRED!)
@override
Widget build(BuildContext context) {
  AppDimensions.init(context);
  return Scaffold(...);
}

// 2. Spacing (Fixed Values)
SizedBox(height: AppDimensions.spaceM)  // 16px
SizedBox(width: AppDimensions.spaceL)   // 24px

// 3. Spacing (Responsive)
SizedBox(height: AppDimensions.spacingMedium(context))  // 16-24px responsive
SizedBox(height: AppDimensions.spacingLarge(context))   // 24-40px responsive

// 4. Padding (Constants - Simple)
SizedBox(height: AppDimensions.paddingSmall)   // 8px
SizedBox(height: AppDimensions.paddingMedium)  // 16px
SizedBox(height: AppDimensions.paddingLarge)   // 24px

// 5. Padding (EdgeInsets)
Container(
  padding: AppDimensions.paddingM,  // 16px all sides
  // OR
  padding: AppDimensions.paddingHorizontalL,  // 24px left-right
)

// 6. Responsive Padding
Container(
  padding: EdgeInsets.all(
    AppDimensions.responsive(context, mobile: 15, tablet: 24, desktop: 32),
  ),
)

// 7. Border Radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppDimensions.radiusM),  // 12px
  ),
)

// 8. Complete Example
Column(
  children: [
    Text('Title'),
    SizedBox(height: AppDimensions.paddingMedium),  // ✅ Constant
    Container(
      padding: EdgeInsets.all(
        AppDimensions.responsive(context, mobile: 15, tablet: 24, desktop: 32),
      ),
      child: Text('Content'),
    ),
  ],
)

============================================ */