import 'package:flutter/material.dart';
import 'package:qr_ksa/screens/event_security_screen.dart';
import 'package:qr_ksa/screens/home_screen.dart';
import 'package:qr_ksa/screens/login_event_security_screen.dart';
import 'package:qr_ksa/screens/otp_screen.dart';
import 'package:qr_ksa/screens/scan_qr_screen.dart';

// استيراد جميع الشاشات هنا
import 'package:qr_ksa/screens/splash_screen.dart';
import 'package:qr_ksa/screens/welcome_screen.dart';
import 'package:qr_ksa/screens/login_screen.dart';
import 'package:qr_ksa/screens/signup_screen.dart';
//import 'package:qr_ksa/screens/home_screen.dart';
//import 'package:qr_ksa/screens/create_event_screen.dart';
//import 'package:qr_ksa/screens/add_attendees_screen.dart';
//import 'package:qr_ksa/screens/payment_screen.dart';
//import 'package:qr_ksa/screens/payment_success_screen.dart';
//import 'package:qr_ksa/screens/qr_cards_screen.dart';
//import 'package:qr_ksa/screens/event_security_screen.dart';
//import 'package:qr_ksa/screens/scan_qr_screen.dart';
//import 'package:qr_ksa/screens/profile_screen.dart';
//import 'package:qr_ksa/screens/settings_screen.dart';
//import 'package:qr_ksa/screens/support_screen.dart';
//import 'package:qr_ksa/screens/event_analytics_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/scan-qr':
        return MaterialPageRoute(builder: (_) => const ScanQRScreen());
      case '/profile': /*
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/support':
        return MaterialPageRoute(builder: (_) => const SupportScreen());
      case '/event-analytics':*/
        return MaterialPageRoute(builder: (_) => const EventSecurityScreen());
      case '/otp':
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(phoneNumber: ''),
        );
      // شاشة تسجيل دخول الأمن
      case '/login-event-security':
        return MaterialPageRoute(
          builder: (_) => const LoginEventSecurityScreen(),
        );
      // شاشة داشبورد الأمن
      case '/event-security-dashboard':
        return MaterialPageRoute(builder: (_) => const EventSecurityScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('الصفحة غير موجودة!'))),
        );
    }
  }
}
