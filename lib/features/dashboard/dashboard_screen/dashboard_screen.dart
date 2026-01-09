import 'package:flutter/material.dart';
import 'package:speedforce_ev/core/widgets/section_header.dart';
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
import 'widget/partner_card.dart'; // Reusable PartnerCard import
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
  late ScrollController _partnerScrollController;

  UserState? _userState;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserState();
    _setupAutoScroll();
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

  void _setupAutoScroll() {
    _partnerScrollController = ScrollController();

    // Auto scroll start karne ke liye delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _partnerScrollController.hasClients) {
        _autoScrollPartners();
      }
    });
  }

  void _autoScrollPartners() {
    if (!mounted || !_partnerScrollController.hasClients) return;

    final maxScroll = _partnerScrollController.position.maxScrollExtent;
    final currentScroll = _partnerScrollController.offset;
    final scrollDistance = 172.0; // Card width + margin

    // Agar end tak pahunch gaye to wapas start pe jao
    if (currentScroll >= maxScroll - 10) {
      _partnerScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).then((_) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _autoScrollPartners();
        });
      });
    } else {
      // Agle card tak scroll karo
      _partnerScrollController.animateTo(
        currentScroll + scrollDistance,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      ).then((_) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _autoScrollPartners();
        });
      });
    }
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
    _partnerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                    mobile: 20,
                    tablet: 28,
                    desktop: 36,
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
        const SizedBox(height: 24),

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

        const SizedBox(height: 24),

        // Quick Stats
        _buildQuickStats(),
        const SizedBox(height: 24),

        // How It Works
        if (_userState!.investmentCount == 0) ...[
          _buildHowItWorksMinimal(),
          const SizedBox(height: 24),
        ],

        // Investment Calculator
        InvestmentCalculatorCard(),
        const SizedBox(height: 24),
        _buildTrustBadge(),
        const SizedBox(height: 24),
        // Latest News & Updates
        _buildNewsSection(),
        const SizedBox(height: 24),

        // Trust Badge


        // Video Section
        VideoSection(),
        const SizedBox(height: 24),

        // Partners - Horizontal Only
        _buildPartnersHorizontal(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPartnersHorizontal() {
    // Aapke partner logos ki list
    final partnerLogos = [
      'assets/images/joy_img.png',
      'assets/images/wardwizard_logo.png',
      'assets/images/jiothings_logo.png',
      'assets/images/img.png',
      'assets/images/img_1.png',
      'assets/images/img_2.png',
      'assets/images/img.png',
      'assets/images/img_1.png',
      'assets/images/img_2.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Our Partners',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // View All button action
              },
              icon: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              label: const Icon(Icons.arrow_forward_ios, size: 14),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: partnerLogos.length,
            itemBuilder: (context, index) {
              // Reusable PartnerCard ka use
              return PartnerCard(
                logoPath: partnerLogos[index],
                width: 160,
                height: 90,
                onTap: () {
                  // Partner card click karne par kya hoga
                  print('Partner tapped: ${partnerLogos[index]}');
                },
              );
            },
          ),
        ),
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
       SectionHeader(title:' Latest Updates'),
        SizedBox(height: 8),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFBAE6FD),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Investing Today',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Join 5000+ investors earning monthly',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
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
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Get Started Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
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
      {
        'value': '5K+',
        'label': 'Investors',
        'icon': Icons.groups_outlined,
        'color': const Color(0xFF8B5CF6),
        'bgColor': const Color(0xFFF5F3FF),
      },
      {
        'value': '15%',
        'label': 'Returns',
        'icon': Icons.show_chart,
        'color': const Color(0xFF10B981),
        'bgColor': const Color(0xFFECFDF5),
      },
      {
        'value': '₹50Cr+',
        'label': 'Deployed',
        'color': const Color(0xFF3B82F6),
        'bgColor': const Color(0xFFEFF6FF),
        'icon': Icons.account_balance_outlined,
      },
      {
        'value': '100%',
        'label': 'On-time',
        'icon': Icons.task_alt,
        'color': const Color(0xFFF59E0B),
        'bgColor': const Color(0xFFFEF3C7),
      },
    ];

    return SizedBox(
      height: 105,
      child: Row(
        children: stats.map((stat) {
          final isLast = stats.last == stat;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: isLast ? 0 : 10),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              decoration: BoxDecoration(
                color: stat['bgColor'] as Color,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (stat['color'] as Color).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    stat['icon'] as IconData,
                    color: stat['color'] as Color,
                    size: 25,
                  ),
                  const SizedBox(height: 5),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stat['value'] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: stat['color'] as Color,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stat['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHowItWorksMinimal() {
    final steps = [
      {
        'title': 'Complete KYC',
        'subtitle': 'Quick 2-min verification',
        'icon': Icons.badge_outlined,
      },
      {
        'title': 'Select Plan',
        'subtitle': 'Choose investment amount',
        'icon': Icons.wallet_outlined,
      },
      {
        'title': 'Start Earning',
        'subtitle': 'Monthly rental income',
        'icon': Icons.payments_outlined,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How It Works',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      step['icon'] as IconData,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          step['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTrustBadge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFBBF7D0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Color(0xFF10B981),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RBI Registered & Insured',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your investments are 100% secure',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Color(0xFF10B981),
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