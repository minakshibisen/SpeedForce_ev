// ═══════════════════════════════════════════════════════════════
// File: lib/core/services/user_service.dart
// Complete User State Management Service
// ═══════════════════════════════════════════════════════════════

import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════
// USER TYPE ENUM
// ═══════════════════════════════════════════════════════════════
enum UserType {
  newUser,        // No investment yet
  investor,       // Has 1 investment
  reInvestor,     // Has 2+ investments
}

// ═══════════════════════════════════════════════════════════════
// USER STATE MODEL
// ═══════════════════════════════════════════════════════════════
class UserState {
  final UserType userType;
  final String userName;
  final String userEmail;
  final String userPhone;
  final bool hasCompletedRegistration;
  final bool hasCompletedOTP;
  final bool hasCompletedKYC;
  final int investmentCount;
  final double totalInvestmentValue;
  final double totalMonthlyRent;
  final String rentPaidStatus;

  UserState({
    required this.userType,
    this.userName = 'Guest User',
    this.userEmail = 'guest@example.com',
    this.userPhone = '',
    this.hasCompletedRegistration = false,
    this.hasCompletedOTP = false,
    this.hasCompletedKYC = false,
    this.investmentCount = 0,
    this.totalInvestmentValue = 0.0,
    this.totalMonthlyRent = 0.0,
    this.rentPaidStatus = '0/48',

  });

  // Helper getters
  bool get shouldShowInvestmentCard => investmentCount > 0;
  bool get shouldShowInvestMore => investmentCount > 1;
}

// ═══════════════════════════════════════════════════════════════
// USER SERVICE CLASS
// ═══════════════════════════════════════════════════════════════
class UserService {
  // SharedPreferences Keys
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyRegistrationComplete = 'registration_complete';
  static const String _keyOTPComplete = 'otp_complete';
  static const String _keyKYCComplete = 'kyc_complete';
  static const String _keyInvestmentCount = 'investment_count';
  static const String _keyTotalInvestment = 'total_investment';
  static const String _keyMonthlyRent = 'monthly_rent';
  static const String _keyRentPaid = 'rent_paid';

  static bool _isKycCompleted = false;

  // ═══════════════════════════════════════════════════════════════
  // GET USER STATE (Main Method)
  // ═══════════════════════════════════════════════════════════════
  static Future<UserState> getUserState() async {
    final prefs = await SharedPreferences.getInstance();

    // Get all user data
    final userName = prefs.getString(_keyUserName) ?? 'Guest User';
    final userEmail = prefs.getString(_keyUserEmail) ?? 'guest@example.com';
    final userPhone = prefs.getString(_keyUserPhone) ?? '';
    final hasRegistration = prefs.getBool(_keyRegistrationComplete) ?? false;
    final hasOTP = prefs.getBool(_keyOTPComplete) ?? false;
    final hasKYC = prefs.getBool(_keyKYCComplete) ?? false;
    final investmentCount = prefs.getInt(_keyInvestmentCount) ?? 0;
    final totalInvestment = prefs.getDouble(_keyTotalInvestment) ?? 0.0;
    final monthlyRent = prefs.getDouble(_keyMonthlyRent) ?? 0.0;
    final rentPaid = prefs.getString(_keyRentPaid) ?? '0/48';

    // ✅ Determine user type based on investment count
    UserType userType;
    if (investmentCount == 0) {
      userType = UserType.newUser;
    } else if (investmentCount == 1) {
      userType = UserType.investor;
    } else {
      userType = UserType.reInvestor;
    }

    return UserState(
      userType: userType,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      hasCompletedRegistration: hasRegistration,
      hasCompletedOTP: hasOTP,
      hasCompletedKYC: hasKYC,
      investmentCount: investmentCount,
      totalInvestmentValue: totalInvestment,
      totalMonthlyRent: monthlyRent,
      rentPaidStatus: rentPaid,

    );
  }

  // ═══════════════════════════════════════════════════════════════
  // REGISTRATION
  // ═══════════════════════════════════════════════════════════════
  static Future<void> completeRegistration({
    required String userId,
    required String userName,
    required String userEmail,
    required String userPhone,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, userName);
    await prefs.setString(_keyUserEmail, userEmail);
    await prefs.setString(_keyUserPhone, userPhone);
    await prefs.setBool(_keyRegistrationComplete, true);

    print('✅ Registration completed for: $userName');
  }

  // ═══════════════════════════════════════════════════════════════
  // OTP VERIFICATION
  // ═══════════════════════════════════════════════════════════════
  static Future<void> completeOTP() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOTPComplete, true);

    print('✅ OTP verification completed');
  }

  // ═══════════════════════════════════════════════════════════════
  // KYC VERIFICATION
  // ═══════════════════════════════════════════════════════════════
  static Future<void> completeKYC() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyKYCComplete, true);

    print('✅ KYC verification completed');
  }

  // ═══════════════════════════════════════════════════════════════
  // ADD INVESTMENT (Most Important)
  // ═══════════════════════════════════════════════════════════════
  static Future<void> addInvestment({
    required double amount,
    required double monthlyRent,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get current values
    final currentCount = prefs.getInt(_keyInvestmentCount) ?? 0;
    final currentTotal = prefs.getDouble(_keyTotalInvestment) ?? 0.0;
    final currentRent = prefs.getDouble(_keyMonthlyRent) ?? 0.0;

    // Update values
    final newCount = currentCount + 1;
    final newTotal = currentTotal + amount;
    final newRent = currentRent + monthlyRent;

    await prefs.setInt(_keyInvestmentCount, newCount);
    await prefs.setDouble(_keyTotalInvestment, newTotal);
    await prefs.setDouble(_keyMonthlyRent, newRent);
    await prefs.setString(_keyRentPaid, '0/48'); // Reset rent paid

    print('✅ Investment added:');
    print('   Amount: ₹$amount');
    print('   Monthly Rent: ₹$monthlyRent');
    print('   Total Investments: $newCount');
    print('   Total Value: ₹$newTotal');
  }


  static Future<void> loginWithMobile(String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Common login flags
    await prefs.setBool(_keyRegistrationComplete, true);
    await prefs.setBool(_keyOTPComplete, true);

    // 🔥 DEMO INVESTOR MOBILE
    if (mobile == '9999999999') {
      await prefs.setString(_keyUserId, 'INV_999');
      await prefs.setString(_keyUserName, 'Demo Investor');
      await prefs.setString(_keyUserEmail, 'investor@demo.com');
      await prefs.setString(_keyUserPhone, mobile);

      await prefs.setBool(_keyKYCComplete, true);

      await prefs.setInt(_keyInvestmentCount, 2);
      await prefs.setDouble(_keyTotalInvestment, 1500000);
      await prefs.setDouble(_keyMonthlyRent, 52800);
      await prefs.setString(_keyRentPaid, '18/48');

      print('✅ Logged in as INVESTOR');
    } else {
      // 👶 New User
      await prefs.setString(_keyUserId, 'NEW_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString(_keyUserName, 'New User');
      await prefs.setString(_keyUserEmail, 'new@user.com');
      await prefs.setString(_keyUserPhone, mobile);

      await prefs.setBool(_keyKYCComplete, false);
      await prefs.setInt(_keyInvestmentCount, 0);

      print('🆕 Logged in as NEW USER');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // UPDATE RENT PAID STATUS
  // ═══════════════════════════════════════════════════════════════
  static Future<void> updateRentPaid(String rentPaidStatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRentPaid, rentPaidStatus);

    print('✅ Rent status updated: $rentPaidStatus');
  }

  // ═══════════════════════════════════════════════════════════════
  // CHECK IF USER NEEDS ONBOARDING
  // ═══════════════════════════════════════════════════════════════
  static Future<bool> needsOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRegistration = prefs.getBool(_keyRegistrationComplete) ?? false;
    return !hasRegistration;
  }

  // ═══════════════════════════════════════════════════════════════
  // GET USER INFO
  // ═══════════════════════════════════════════════════════════════
  static Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'userId': prefs.getString(_keyUserId) ?? '',
      'userName': prefs.getString(_keyUserName) ?? 'Guest User',
      'userEmail': prefs.getString(_keyUserEmail) ?? 'guest@example.com',
      'userPhone': prefs.getString(_keyUserPhone) ?? '',
    };
  }
  static Future<void> onKycSkipped() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_keyInvestmentCount, 0);
    await prefs.setDouble(_keyTotalInvestment, 0.0);
    await prefs.setDouble(_keyMonthlyRent, 0.0);
    await prefs.setString(_keyRentPaid, '0/48');

    await prefs.setBool(_keyKYCComplete, false);

    print('🚫 KYC skipped → User treated as NEW USER');
  }

  // ═══════════════════════════════════════════════════════════════
  // GET INVESTMENT DETAILS
  // ═══════════════════════════════════════════════════════════════
  static Future<Map<String, dynamic>> getInvestmentDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'count': prefs.getInt(_keyInvestmentCount) ?? 0,
      'totalInvestment': prefs.getDouble(_keyTotalInvestment) ?? 0.0,
      'monthlyRent': prefs.getDouble(_keyMonthlyRent) ?? 0.0,
      'rentPaid': prefs.getString(_keyRentPaid) ?? '0/48',
    };
  }

  // ═══════════════════════════════════════════════════════════════
  // CLEAR ALL DATA (Logout)
  // ═══════════════════════════════════════════════════════════════
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    print('✅ All user data cleared');
  }

  // ═══════════════════════════════════════════════════════════════
  // TESTING HELPERS
  // ═══════════════════════════════════════════════════════════════

  static Future<void> resetToNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await prefs.setString(_keyUserName, 'Test User');
    await prefs.setString(_keyUserEmail, 'test@example.com');

    await prefs.setBool(_keyRegistrationComplete, true);
    await prefs.setBool(_keyOTPComplete, true);

    // ✅ MOST IMPORTANT
    await prefs.setInt(_keyInvestmentCount, 0);
    await prefs.setDouble(_keyTotalInvestment, 0.0);
    await prefs.setDouble(_keyMonthlyRent, 0.0);
    await prefs.setString(_keyRentPaid, '0/48');

    print('✅ TRUE NEW USER CREATED');
  }

  // Set as investor (for testing)
  static Future<void> setAsInvestor() async {
    await resetToNewUser();
    await addInvestment(amount: 500000, monthlyRent: 17600);

    print('✅ Set as INVESTOR state');
  }

  // Set as re-investor (for testing)
  static Future<void> setAsReInvestor() async {
    await resetToNewUser();
    await addInvestment(amount: 500000, monthlyRent: 17600);
    await addInvestment(amount: 1000000, monthlyRent: 35200);

    print('✅ Set as RE-INVESTOR state');
  }

  // Print current state (for debugging)
  static Future<void> printCurrentState() async {
    final state = await getUserState();

    print('\n========================================');
    print('📊 CURRENT USER STATE');
    print('========================================');
    print('User Type: ${state.userType}');
    print('Name: ${state.userName}');
    print('Email: ${state.userEmail}');
    print('Phone: ${state.userPhone}');
    print('----------------------------------------');
    print('Registration: ${state.hasCompletedRegistration ? '✅' : '❌'}');
    print('OTP: ${state.hasCompletedOTP ? '✅' : '❌'}');
    print('KYC: ${state.hasCompletedKYC ? '✅' : '❌'}');
    print('----------------------------------------');
    print('Investment Count: ${state.investmentCount}');
    print('Total Investment: ₹${state.totalInvestmentValue}');
    print('Monthly Rent: ₹${state.totalMonthlyRent}');
    print('Rent Paid: ${state.rentPaidStatus}');
    print('========================================\n');
  }
}

// ═══════════════════════════════════════════════════════════════
// USAGE EXAMPLES
// ═══════════════════════════════════════════════════════════════

/*

// Example 1: Complete Registration
await UserService.completeRegistration(
  userId: 'user_123',
  userName: 'John Doe',
  userEmail: 'john@example.com',
  userPhone: '1234567890',
);

// Example 2: Complete OTP
await UserService.completeOTP();

// Example 3: Complete KYC
await UserService.completeKYC();

// Example 4: Add Investment
await UserService.addInvestment(
  amount: 500000.0,
  monthlyRent: 17600.0,
);

// Example 5: Get User State
final userState = await UserService.getUserState();
if (userState.userType == UserType.newUser) {
  // Show "Invest Now" card
} else if (userState.userType == UserType.investor) {
  // Show investment card without "Invest More"
} else {
  // Show investment card with "Invest More" button
}

// Example 6: Check if needs onboarding
final needsOnboarding = await UserService.needsOnboarding();
if (needsOnboarding) {
  // Navigate to registration
}

// Example 7: Clear all data (logout)
await UserService.clearUserData();

// TESTING EXAMPLES:

// Reset to new user
await UserService.resetToNewUser();

// Set as investor
await UserService.setAsInvestor();

// Set as re-investor
await UserService.setAsReInvestor();

// Print current state
await UserService.printCurrentState();

*/