import 'package:flutter/material.dart';
import 'package:speedforce_ev/core/widgets/custom_button.dart';
import 'package:speedforce_ev/features/dashboard/home_screen.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/text_styles.dart';

class ExpectedRoiScreen extends StatefulWidget {
  const ExpectedRoiScreen({super.key});

  @override
  State<ExpectedRoiScreen> createState() => _ExpectedRoiScreenState();
}

class _ExpectedRoiScreenState extends State<ExpectedRoiScreen> {
  int investment = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _title(),
              const SizedBox(height: 32),
              _investmentSlider(),
              const SizedBox(height: 32),
              _roiField('Monthly Returns', '₹17,600'),
              _roiField('Annual Returns', '₹211,200'),
              _roiField('Total Returns After 4 Years', '₹844,800'),
              _roiField('Salvage Value (15% after 48 months)', '₹75,000'),
              _roiField('Total After 4 Years + Bonus', '₹919,800'),

              // _totalReturnCard(),
              // const SizedBox(height: 24),
              // _roiGrid(),
              const SizedBox(height: 40),
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
                      text: 'Start Investing',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _roiField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
  // ───────────────── TITLE ─────────────────
  Widget _title() {
    return Column(
      children: [
        Text(
          'Expected ROI',
          style: AppTextStyles.heading3(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
         Text(
          '4 Year Investment Outlook',
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ───────────────── SLIDER ─────────────────

  Widget _investmentSlider() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Investment Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6FBF44).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '4 Year Plan',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6FBF44),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Amount pill
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
              const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6FBF44), Color(0xFF8EDC6E)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.currency_rupee,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '$investment Lacs',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape:
              const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape:
              const RoundSliderOverlayShape(overlayRadius: 18),
              activeTrackColor: const Color(0xFF6FBF44),
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: const Color(0xFF6FBF44),
            ),
            child: Slider(
              value: investment.toDouble(),
              min: 1,
              max: 50,
              divisions: 49,
              onChanged: (value) {
                setState(() => investment = value.round());
              },
            ),
          ),

          // Range labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('₹1 Lac',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('₹50 Lacs',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────── TOTAL RETURN CARD ─────────────────

  Widget _totalReturnCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6FBF44),
            Color(0xFF8EDC6E),
          ],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Returns in 4 Years',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '₹ 9,19,800',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── ROI GRID ─────────────────

  Widget _roiGrid() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      children: const [
        _RoiCard(title: 'Monthly Return', value: '₹17,600'),
        _RoiCard(title: 'Annual Return', value: '₹2,11,200'),
        _RoiCard(title: '4 Year Return', value: '₹8,44,800'),
        _RoiCard(title: 'Salvage Value', value: '₹75,000'),
      ],
    );
  }

  // ───────────────── BOTTOM BUTTON ─────────────────

  Widget _bottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6FBF44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            'Start Investing',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────── ROI CARD ─────────────────

class _RoiCard extends StatelessWidget {
  final String title;
  final String value;

  const _RoiCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
