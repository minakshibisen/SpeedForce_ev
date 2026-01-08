import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/dashboard/investment_overview_screen.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';
import '../../../core/sevice/user_service.dart';

import '../../auth/presentation/kyc_screen.dart';
import '../../auth/presentation/investment_slab_screen.dart';
import 'widget/dashboard_header.dart';
import 'widget/emptyInvestmentCard.dart';
import 'widget/investment_summary_card.dart';
import 'widget/partner_card.dart';
import 'widget/video_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  UserState? _userState;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserState();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  Future<void> _loadUserState() async {
    final userState = await UserService.getUserState();
    setState(() {
      _userState = userState;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
              SizedBox(height: AppDimensions.paddingMedium),
              Text(
                'Loading your dashboard...',
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: EdgeInsets.all(
                      AppDimensions.responsive(
                        context,
                        mobile: 15,
                        tablet: 24,
                        desktop: 32,
                      ),
                    ),
                    child: _buildContent(constraints),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: AppDimensions.responsive(
        context,
        mobile: 150,
        tablet: 180,
        desktop: 200,
      ),
      floating: false,
      pinned: true,
      snap: false,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: DashboardHeader(
          userName: _userState!.userName,
          userEmail: _userState!.userEmail,
        ),
      ),
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    final isMobile = constraints.maxWidth < 600;
    final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_userState!.investmentCount == 0)
          EmptyInvestmentCard(
            onInvestNow: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const KycVerificationScreen(
                    mode: KycFlowMode.mandatory,
                  ),
                ),
              );
              _loadUserState();
            },
          )
        else
          InvestmentSummaryCard(
            investmentValue: _userState!.totalInvestmentValue,
            monthlyRent: _userState!.totalMonthlyRent,
            rentPaid: _userState!.rentPaidStatus,
            showInvestMore: _userState!.userType == UserType.reInvestor,
            onViewDetails: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvestmentOverviewScreen(),
                ),
              );
            },
            onShare: () {},
            onInvestMore: _userState!.userType == UserType.reInvestor
                ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InvestmentSlabScreen(),
                ),
              );
              _loadUserState();
            }
                : null,
          ),
        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),
        VideoSection(),
        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),
        PartnersSection(),
        SizedBox(height: AppDimensions.paddingLarge),
      ],
    );
  }
}

// ============= REUSABLE: DASHBOARD HEADER =============


// ============= REUSABLE: EMPTY INVESTMENT CARD =============

// ============= REUSABLE: INVESTMENT SUMMARY CARD =============

// ============= REUSABLE: STAT ITEM =============


// ============= REUSABLE: VIDEO SECTION =============

// ============= REUSABLE: VIDEO CARD =============

// ============= REUSABLE: PARTNERS SECTION =============


// ============= REUSABLE: SECTION HEADER =============
