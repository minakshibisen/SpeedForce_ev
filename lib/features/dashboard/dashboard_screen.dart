import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 20),
              _investmentCard(),
              const SizedBox(height: 24),
              _videosSection(),
              const SizedBox(height: 24),
              _partnersSection(),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER
  Widget _header() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Name',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('user.name@gmail.com',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Stack(
          children: [
            const Icon(Icons.notifications_none, size: 26),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '4',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  // INVESTMENT CARD
  Widget _investmentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          const Text('Investment Value',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          const Text(
            '₹500,000.00',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6FBF44),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile(Icons.calendar_today, 'Monthly Rent', '₹17,600.00'),
              _infoTile(Icons.check_circle, 'Rent Paid', '2/48'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _actionButton('View Details', filled: true),
              const SizedBox(width: 12),
              _actionButton('Share'),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Last updated 5m ago   Sync now',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(value,
                style:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        )
      ],
    );
  }

  Widget _actionButton(String title, {bool filled = false}) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF6FBF44) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: filled ? null : Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: filled ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // VIDEOS
  Widget _videosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Videos'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_outline, size: 36),
            ),
          ),
        )
      ],
    );
  }

  // PARTNERS
  Widget _partnersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Partners', action: 'Detail'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            alignment: Alignment.center,
            child: const Text(
              'LOGO',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }

  Widget _sectionHeader(String title, {String? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
        if (action != null)
          Text(action,
              style: const TextStyle(fontSize: 12, color: Colors.green))
      ],
    );
  }

  // BOTTOM NAV
  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: const Color(0xFF6FBF44),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Fleet'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
