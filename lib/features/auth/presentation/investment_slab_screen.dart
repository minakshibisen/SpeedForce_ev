import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/auth/presentation/expected_roi_screen.dart';
import 'package:speedforce_ev/features/dashboard/home_screen.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';
import '../../../core/widgets/custom_button.dart';

// ✅ STEP 1: Import Dashboard
import '../../dashboard/dashboard_screen/dashboard_screen.dart';

class InvestmentSlabScreen extends StatefulWidget {
  const InvestmentSlabScreen({super.key});

  @override
  State<InvestmentSlabScreen> createState() => _InvestmentSlabScreenState();
}

class _InvestmentSlabScreenState extends State<InvestmentSlabScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 4;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ✅ STEP 2: Add actual slab amounts
  final List<Map<String, dynamic>> slabs = [
    {'label': '2.5 Lacs', 'amount': 250000.0},
    {'label': '5 Lacs', 'amount': 500000.0},
    {'label': '10 Lacs', 'amount': 1000000.0},
    {'label': '15–20 Lacs', 'amount': 1750000.0},
    {'label': '20–30 Lacs', 'amount': 2500000.0},
    {'label': '30–40 Lacs', 'amount': 3500000.0},
    {'label': '40–50 Lacs', 'amount': 4500000.0},
    {'label': '50+ Lacs', 'amount': 5000000.0},
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ✅ STEP 3: Add Skip function
  void _onSkip() {
    // Navigate to Dashboard without selecting slab
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
          (route) => false,
    );
  }

  // ✅ STEP 4: Add Continue function with selected amount
  void _onContinue() {
    final selectedAmount = slabs[selectedIndex]['amount'];

    // Navigate to ROI Screen with selected amount
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ExpectedRoiScreen(
          selectedAmount: selectedAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      // ✅ STEP 5: Add AppBar with back button
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildProgressIndicator(),
                  const SizedBox(height: 32),
                  Expanded(child: _buildSlabGrid()),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [ AppColors.primary, AppColors.primary],
          ).createShader(bounds),
          child: Text(
            'Choose Investment Slab',
            style: AppTextStyles.heading3(context).copyWith(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Select the total amount to be invested',
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == 2 ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
            index == 2 ?   AppColors.primary :  Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildSlabGrid() {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: slabs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final isSelected = index == selectedIndex;
        final slab = slabs[index];

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ?   AppColors.primary
                    : Colors.grey.shade200,
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ?   AppColors.primary.withOpacity(0.25)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: isSelected ? 12 : 8,
                  offset: Offset(0, isSelected ? 4 : 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '₹${slab['label']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                      color:
                      isSelected ?   AppColors.primary : Colors.black87,
                    ),
                  ),
                ),
                AnimatedScale(
                  scale: isSelected ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color:  AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ STEP 6: Updated Action Buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:   AppColors.primary.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _onSkip, // ✅ Updated to call _onSkip
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:  AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [ AppColors.primary, AppColors.primary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color:   AppColors.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _onContinue, // ✅ Updated to call _onContinue
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}