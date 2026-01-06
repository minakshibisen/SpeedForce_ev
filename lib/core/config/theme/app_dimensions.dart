import 'package:flutter/material.dart';

/// AppDimensions - Centralized responsive sizing system
/// Ek jagah change karo, sab jagah update ho jayega!
class AppDimensions {
  // ============ Screen Size Variables ============
  static late double screenWidth;
  static late double screenHeight;

  /// Initialize karo har screen ke build method mein
  /// Usage: AppDimensions.init(context);
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  // ============ Responsive Helpers ============

  /// Responsive width (based on 375px iPhone SE width)
  /// Usage: AppDimensions.width(200)
  static double width(double size) => (screenWidth / 375) * size;

  /// Responsive height (based on 812px iPhone X height)
  /// Usage: AppDimensions.height(100)
  static double height(double size) => (screenHeight / 812) * size;

  /// Responsive font size
  /// Usage: AppDimensions.fontSize(16)
  static double fontSize(double size) => (screenWidth / 375) * size;

  // ============ Spacing Constants ============
  // Ek jagah change karo, pure app mein update ho jayega!

  static const double spaceXS = 4.0;   // Extra Small
  static const double spaceS = 8.0;    // Small
  static const double spaceM = 16.0;   // Medium (default)
  static const double spaceL = 24.0;   // Large
  static const double spaceXL = 32.0;  // Extra Large
  static const double spaceXXL = 48.0; // Extra Extra Large

  // ============ Helper Methods (Responsive Spacing) ============

  /// Small spacing - responsive
  /// Mobile: 8px, Tablet: 12px, Desktop: 12px
  static double spacingSmall(BuildContext context) {
    return responsive(context, mobile: spaceS, tablet: 12.0, desktop: 12.0);
  }

  /// Medium spacing - responsive
  /// Mobile: 16px, Tablet: 20px, Desktop: 24px
  static double spacingMedium(BuildContext context) {
    return responsive(context, mobile: spaceM, tablet: 20.0, desktop: spaceL);
  }

  /// Large spacing - responsive
  /// Mobile: 24px, Tablet: 32px, Desktop: 40px
  static double spacingLarge(BuildContext context) {
    return responsive(context, mobile: spaceL, tablet: spaceXL, desktop: 40.0);
  }

  /// Extra large spacing - responsive
  /// Mobile: 32px, Tablet: 48px, Desktop: 64px
  static double spacingXLarge(BuildContext context) {
    return responsive(context, mobile: spaceXL, tablet: spaceXXL, desktop: 64.0);
  }

  // ============ Helper Methods (Responsive Padding) ============

  /// Small padding - responsive
  /// Mobile: 8px, Tablet: 12px, Desktop: 12px
  static double paddingSmall(BuildContext context) {
    return responsive(context, mobile: spaceS, tablet: 12.0, desktop: 12.0);
  }

  /// Medium padding - responsive
  /// Mobile: 16px, Tablet: 20px, Desktop: 24px
  static double paddingMedium(BuildContext context) {
    return responsive(context, mobile: spaceM, tablet: 20.0, desktop: spaceL);
  }

  /// Large padding - responsive
  /// Mobile: 24px, Tablet: 32px, Desktop: 40px
  static double paddingLarge(BuildContext context) {
    return responsive(context, mobile: spaceL, tablet: spaceXL, desktop: 40.0);
  }

  /// Extra large padding - responsive
  /// Mobile: 32px, Tablet: 48px, Desktop: 64px
  static double paddingXLarge(BuildContext context) {
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

  // Default screen padding (use in all screens)
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
  /// Usage:
  /// ```dart
  /// AppDimensions.responsive(
  ///   context,
  ///   mobile: 16,
  ///   tablet: 18,
  ///   desktop: 20,
  /// )
  /// ```
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
   USAGE EXAMPLES
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

// 3. Spacing (Responsive - NEW!)
SizedBox(height: AppDimensions.spacingMedium(context))  // 16-24px responsive
SizedBox(height: AppDimensions.spacingLarge(context))   // 24-40px responsive

// 4. Padding (Fixed EdgeInsets)
Container(
  padding: AppDimensions.paddingM,  // 16px all sides
  // OR
  padding: AppDimensions.paddingHorizontalL,  // 24px left-right
)

// 5. Padding (Responsive - NEW!)
Container(
  padding: EdgeInsets.all(AppDimensions.paddingLarge(context)),  // 24-40px responsive
)

// 6. Border Radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppDimensions.radiusM),  // 12px
  ),
)

// 7. Button Height
CustomButton(
  height: AppDimensions.buttonHeightL,  // 56px
)

// 8. Icon Size
Icon(
  Icons.home,
  size: AppDimensions.iconM,  // 24px
)

// 9. Responsive Values (Generic)
Text(
  'Hello',
  style: TextStyle(
    fontSize: AppDimensions.responsive(
      context,
      mobile: 16,    // Shows on phones
      tablet: 18,    // Shows on tablets
      desktop: 20,   // Shows on desktop
    ),
  ),
)

// 10. Responsive Width/Height
Container(
  width: AppDimensions.width(200),   // Scales with screen
  height: AppDimensions.height(100), // Scales with screen
)

// 11. Device Type Check
if (AppDimensions.isMobile(context)) {
  // Mobile layout
} else if (AppDimensions.isTablet(context)) {
  // Tablet layout
} else {
  // Desktop layout
}

// 12. Complete Example with Helper Methods
Column(
  children: [
    Text('Title'),
    SizedBox(height: AppDimensions.spacingMedium(context)),  // ✅ Responsive
    Container(
      padding: EdgeInsets.all(AppDimensions.paddingLarge(context)),  // ✅ Responsive
      child: Text('Content'),
    ),
  ],
)

============================================ */