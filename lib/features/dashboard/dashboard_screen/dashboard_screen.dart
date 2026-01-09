import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/dashboard/dashboard_screen/widget/investment_calculator_card.dart';
import 'package:speedforce_ev/features/dashboard/investment_overview_screen.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';
import '../../../core/sevice/user_service.dart';
import '../../auth/presentation/kyc_screen.dart' hide InvestmentSlabScreen;
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
      duration: const Duration(milliseconds: 600),
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
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.responsive(
                    context,
                    mobile: 16,
                    tablet: 24,
                    desktop: 32,
                  ),
                ),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final appBarHeight = screenWidth < 600 ? 100.0 : 110.0;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DashboardHeaderDelegate(
        minHeight: appBarHeight,
        maxHeight: appBarHeight,
        child: DashboardHeader(
          userName: _userState!.userName,
          userEmail: _userState!.userEmail,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),

        // Latest News & Updates
        _buildNewsSection(),
        SizedBox(height: 24),

        // Investment Status
        if (_userState!.investmentCount == 0)
          _buildFirstTimeUserSection()
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

        SizedBox(height: 32),

        // Quick Stats
        _buildQuickStats(),
        SizedBox(height: 32),

        // How It Works - Simple 3 Steps
        if (_userState!.investmentCount == 0) ...[
          _buildHowItWorksMinimal(),
          SizedBox(height: 32),
        ],

        // Investment Calculator
        InvestmentCalculatorCard(),
        SizedBox(height: 32),

        // Trust Badge
        _buildTrustBadge(),
        SizedBox(height: 32),

        // Video Section
        VideoSection(),
        SizedBox(height: 32),

        // Partners
        PartnersSection(),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildNewsSection() {
    // Mock news data - replace with API call
    final news = [
      {
        'tag': 'NEW',
        'title': '1000+ E-bikes successfully deployed in Mumbai',
        'time': '2 hours ago',
        'color': Colors.green,
      },
      {
        'tag': 'UPDATE',
        'title': 'December rent payments completed - 100% on time',
        'time': '5 hours ago',
        'color': Colors.blue,
      },
      {
        'tag': 'MILESTONE',
        'title': 'SpeedForce crosses ₹100Cr in total investments',
        'time': '1 day ago',
        'color': Colors.orange,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Latest Updates',
              style: AppTextStyles.heading1(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: news.length,
            itemBuilder: (context, index) {
              final item = news[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.75,
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['tag'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: item['color'] as Color,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          item['time'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFirstTimeUserSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.primary.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.rocket_launch,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Your Investment Journey',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Join 5000+ investors earning monthly',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'Get Started Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final stats = [
      {'value': '5000+', 'label': 'Investors', 'icon': Icons.people_outline},
      {'value': '15%', 'label': 'Annual Return', 'icon': Icons.trending_up},
      {'value': '₹50Cr+', 'label': 'Deployed', 'icon': Icons.account_balance_wallet_outlined},
      {'value': '100%', 'label': 'On-time Rent', 'icon': Icons.verified_outlined},
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: stats.last == stat ? 0 : 8),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  stat['icon'] as IconData,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(height: 8),
                Text(
                  stat['value'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  stat['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHowItWorksMinimal() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How It Works',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          _buildStepItem(1, 'Verify KYC', 'Complete quick verification', true),
          _buildStepItem(2, 'Choose Plan', 'Select investment amount', true),
          _buildStepItem(3, 'Earn Monthly', 'Get consistent rental income', false),
        ],
      ),
    );
  }

  Widget _buildStepItem(int number, String title, String subtitle, bool showLine) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number.toString(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (showLine)
                  Container(
                    width: 2,
                    height: 32,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrustBadge() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shield_outlined,
              color: Colors.green,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RBI Registered & Insured',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your investments are secure and protected',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.verified,
            color: Colors.green,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class _DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _DashboardHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_DashboardHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}