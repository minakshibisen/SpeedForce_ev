import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/dashboard/dashboard_screen/widget/investment_calculator_card.dart';
import 'package:speedforce_ev/features/dashboard/dashboard_screen/widget/why_invest_ebike_card.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final appBarHeight = screenWidth < 600 ? 100.0 : screenWidth < 900 ? 110.0 : 120.0;

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

  Widget _buildContent(BoxConstraints constraints) {
    final isMobile = constraints.maxWidth < 600;
    final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Investment Status Section
        if (_userState!.investmentCount == 0) ...[
          _buildWelcomeBanner(),
          SizedBox(height: AppDimensions.responsive(context, mobile: 20, tablet: 24, desktop: 28)),
          _buildHowToInvestSection(),
          SizedBox(height: AppDimensions.responsive(context, mobile: 20, tablet: 24, desktop: 28)),
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
          ),
        ] else ...[
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
        ],

        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),

        // Trust Building Section
        _buildTrustIndicators(),

        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),

        // Investment Calculator
        InvestmentCalculatorCard(),

        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),

        // Why Invest Section
        _buildWhyInvestSection(),

        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),

        // Educational Content
        if (_userState!.investmentCount == 0)
          _buildEducationalSection(),

        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),

        // Video Section
        VideoSection(),

        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),

        // Social Proof & Partners
        _buildSocialProofSection(),

        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),

        PartnersSection(),

        SizedBox(height: AppDimensions.responsive(context, mobile: 28, tablet: 32, desktop: 40)),

        // FAQ Section
        _buildFAQSection(),

        SizedBox(height: AppDimensions.paddingLarge),
      ],
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.responsive(context, mobile: 20, tablet: 24, desktop: 28)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎉 Welcome to SpeedForce EV Investment',
            style: AppTextStyles.heading1(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Start your journey to sustainable passive income through e-bike investments',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToInvestSection() {
    final steps = [
      {
        'icon': Icons.verified_user,
        'title': 'Complete KYC',
        'description': 'Quick 2-minute verification process',
      },
      {
        'icon': Icons.payments,
        'title': 'Choose Investment',
        'description': 'Select from flexible investment plans',
      },
      {
        'icon': Icons.electric_bike,
        'title': 'E-bike Deployed',
        'description': 'Your bike starts earning immediately',
      },
      {
        'icon': Icons.account_balance_wallet,
        'title': 'Earn Monthly',
        'description': 'Receive consistent rental income',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.responsive(context, mobile: 20, tablet: 24, desktop: 28)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: AppColors.primary, size: 28),
                SizedBox(width: 12),
                Text(
                  'How to Get Started',
                  style: AppTextStyles.heading1(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: index < steps.length - 1 ? 20 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${step['title']}',
                            style: AppTextStyles.bodyLarge(context).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            step['description'] as String,
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              color: Colors.grey[600],
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
      ),
    );
  }

  Widget _buildTrustIndicators() {
    final indicators = [
      {'icon': Icons.security, 'value': '100%', 'label': 'Secure Payments'},
      {'icon': Icons.verified, 'value': '5000+', 'label': 'Active Investors'},
      {'icon': Icons.trending_up, 'value': '98%', 'label': 'Satisfaction Rate'},
      {'icon': Icons.account_balance, 'value': '₹50Cr+', 'label': 'Assets Deployed'},
    ];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.responsive(context, mobile: 16, tablet: 20, desktop: 24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why Investors Trust Us',
              style: AppTextStyles.heading1(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: indicators.length,
              itemBuilder: (context, index) {
                final item = indicators[index];
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        item['value'] as String,
                        style: AppTextStyles.heading2(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: AppTextStyles.bodySmall(context),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhyInvestSection() {
    final benefits = [
      {
        'icon': Icons.insights,
        'title': 'Consistent Returns',
        'description': 'Earn up to 12-15% annual returns through monthly rental income',
      },
      {
        'icon': Icons.eco,
        'title': 'Sustainable Impact',
        'description': 'Contribute to green transportation and reduce carbon footprint',
      },
      {
        'icon': Icons.lock,
        'title': 'Asset-Backed Security',
        'description': 'Your investment is backed by tangible e-bike assets',
      },
      {
        'icon': Icons.access_time,
        'title': 'Flexible Tenure',
        'description': 'Choose investment periods that suit your financial goals',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.responsive(context, mobile: 20, tablet: 24, desktop: 28)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why Invest in E-Bikes?',
              style: AppTextStyles.heading1(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ...benefits.map((benefit) => Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      benefit['icon'] as IconData,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          benefit['title'] as String,
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          benefit['description'] as String,
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationalSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.responsive(context, mobile: 20, tablet: 24, desktop: 28)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investment Resources',
              style: AppTextStyles.heading1(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildResourceItem(
              Icons.menu_book,
              'Investment Guide',
              'Learn the basics of e-bike investments',
                  () {},
            ),
            Divider(height: 32),
            _buildResourceItem(
              Icons.calculate,
              'ROI Calculator',
              'Calculate potential returns on your investment',
                  () {},
            ),
            Divider(height: 32),
            _buildResourceItem(
              Icons.question_answer,
              'Talk to Expert',
              'Get personalized investment advice',
                  () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(IconData icon, String title, String description, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialProofSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.responsive(context, mobile: 20, tablet: 24, desktop: 28)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What Investors Say',
              style: AppTextStyles.heading1(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildTestimonial(
              'Rajesh Kumar',
              'Invested ₹2,00,000',
              'Great returns and hassle-free process. Receiving monthly rent on time!',
              4.5,
            ),
            Divider(height: 32),
            _buildTestimonial(
              'Priya Sharma',
              'Invested ₹5,00,000',
              'Love the transparency and regular updates. Best passive income option.',
              5.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonial(String name, String investment, String review, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                name[0],
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    investment,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          review,
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: Colors.grey[700],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'Is my investment safe?',
        'answer': 'Yes, your investment is asset-backed and insured. We have robust security measures in place.',
      },
      {
        'question': 'How soon can I start earning?',
        'answer': 'Once your e-bike is deployed, you start earning rental income from the very first month.',
      },
      {
        'question': 'Can I withdraw my investment anytime?',
        'answer': 'Investment terms vary by plan. Early withdrawal options are available with specific conditions.',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.responsive(context, mobile: 20, tablet: 24, desktop: 28)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: AppTextStyles.heading1(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...faqs.map((faq) => ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                faq['question']!,
                style: AppTextStyles.bodyLarge(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 16),
                  child: Text(
                    faq['answer']!,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            )).toList(),
          ],
        ),
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