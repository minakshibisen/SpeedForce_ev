import 'package:flutter/material.dart';
import '../config/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      leading: leading ??
          (showBackButton
              ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final double expandedHeight;
  final bool pinned;
  final bool floating;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.flexibleSpace,
    this.expandedHeight = 200,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(title),
      centerTitle: true,
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      actions: actions,
      flexibleSpace: flexibleSpace,
    );
  }
}

// Usage Examples:
/*
// Basic AppBar
Scaffold(
  appBar: CustomAppBar(
    title: 'Registration',
  ),
  body: YourWidget(),
)

// AppBar without back button
CustomAppBar(
  title: 'Dashboard',
  showBackButton: false,
)

// AppBar with actions
CustomAppBar(
  title: 'Profile',
  actions: [
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {},
    ),
  ],
)

// Custom back action
CustomAppBar(
  title: 'Details',
  onBackPressed: () {
    // Custom back logic
  },
)

// Sliver AppBar in CustomScrollView
CustomScrollView(
  slivers: [
    CustomSliverAppBar(
      title: 'Dashboard',
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.primary,
          child: Center(
            child: Text('Welcome!'),
          ),
        ),
      ),
    ),
    SliverList(...),
  ],
)
*/