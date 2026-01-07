import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Personal Info',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),



      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _ProfileSection(),
            const SizedBox(height: 24),

            _InputField(label: 'Full Name', hint: 'User Name'),
            _InputField(
              label: 'Date of Birth',
              hint: '00/00/0000',
              suffix: Icons.calendar_today_outlined,
            ),
            _InputField(
              label: 'Email',
              hint: 'user.name@gmail.com',
              prefix: Icons.email_outlined,
            ),
            _InputField(
              label: 'Phone Number',
              hint: '+91 00000 00000',
              prefix: Icons.phone_outlined,
            ),
            _InputField(
              label: 'Nominee',
              hint: 'Nominee Name',
              prefix: Icons.person_outline,
            ),

            const SizedBox(height: 24),
            _PaymentMethodSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}


class _ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFFE5E7EB),
              child: Icon(Icons.person, size: 40),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF6FBF44),
                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          child: const Text('Change Photo'),
        ),
      ],
    );
  }
}
class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefix;
  final IconData? suffix;

  const _InputField({
    required this.label,
    required this.hint,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefix != null ? Icon(prefix) : null,
              suffixIcon: suffix != null ? Icon(suffix) : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _PaymentMethodSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        _BankTile(
          name: 'HDFC Bank',
          account: '•••• 1234',
          primary: true,
        ),
        _BankTile(
          name: 'State Bank of India',
          account: '•••• 4321',
        ),

        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add New Bank'),
        ),

        const SizedBox(height: 8),
        Text(
          '• Once bank details are updated, further changes will be allowed after verification.\n'
              '• Only one primary bank account is allowed.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _BankTile extends StatelessWidget {
  final String name;
  final String account;
  final bool primary;

  const _BankTile({
    required this.name,
    required this.account,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: const Icon(Icons.account_balance_outlined),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(account),
        trailing: primary
            ? Chip(
          label: const Text('Primary'),
          backgroundColor: const Color(0xFFDCFCE7),
          labelStyle: const TextStyle(color: Color(0xFF166534)),
        )
            : null,
      ),
    );
  }
}
