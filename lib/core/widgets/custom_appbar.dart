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
class _SimpleHeader extends StatelessWidget {
  final String userName;
  final String userEmail;

  const _SimpleHeader({
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6FBF44), Color(0xFF8EDC6E)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.grey.shade700,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

}// ============= CUSTOM SLIVER HEADER =============
