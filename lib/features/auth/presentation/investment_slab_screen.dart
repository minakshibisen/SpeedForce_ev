import 'package:flutter/material.dart';
import 'package:speedforce_ev/features/auth/presentation/expected_roi_screen.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_dimensions.dart';
import '../../../core/config/theme/text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../dashboard/home_screen.dart';

class InvestmentSlabScreen extends StatefulWidget {
  const InvestmentSlabScreen({super.key});

  @override
  State<InvestmentSlabScreen> createState() =>
      _InvestmentSlabScreenState();
}

class _InvestmentSlabScreenState
    extends State<InvestmentSlabScreen> {
  int selectedIndex = 4;

  final List<String> slabs = [
    '2.5 Lacs',
    '5 Lacs',
    '10 Lacs',
    '15–20 Lacs',
    '20–30 Lacs',
    '30–40 Lacs',
    '40–50 Lacs',
    '50+ Lacs',
    '55-60+ Lacs',
    '60+ Lacs',
    '70+ Lacs',
    '70-75+ Lacs',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingLarge(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              Text(
                'Choose Investment Slab',
                style: AppTextStyles.heading3(context),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Select the total amount to be invested',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
              )),

              const SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: slabs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.6,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6FBF44).withOpacity(0.12)
                              : const Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF6FBF44)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              slabs[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            AnimatedScale(
                              scale: isSelected ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(
                                Icons.check_circle,
                                color: Color(0xFF6FBF44),
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),


              const SizedBox(height: 16),

              // Next Button
              Row(
                children: [

                  Expanded(
                    child: CustomButton(
                      text: 'Skip',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Next',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ExpectedRoiScreen()),
                        );
                      },
                    ),
                  ),

                ],
              ),


              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class _StatusIcon extends StatelessWidget {
  final bool isSelected;

  const _StatusIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.red : Colors.grey.shade300,
      ),
      child: const Icon(
        Icons.check,
        size: 14,
        color: Colors.white,
      ),
    );
  }
}
