import 'package:flutter/material.dart';
import 'package:qr_ksa/features/event/screens/event_security_screen.dart';
import 'package:qr_ksa/features/home/screens/home_screen.dart';
import 'package:qr_ksa/features/event/screens/login_event_security_screen.dart';
import 'package:qr_ksa/features/login/screens/otp_screen.dart';
import 'package:qr_ksa/features/event/screens/scan_qr_screen.dart';
import 'package:qr_ksa/features/home/screens/splash_screen.dart';
import 'package:qr_ksa/features/home/screens/welcome_screen.dart';
import 'package:qr_ksa/features/login/screens/login_screen.dart';
import 'package:qr_ksa/features/signup/screens/signup_screen.dart';
import 'package:qr_ksa/features/event/screens/attendance_list_screen.dart';
import 'package:qr_ksa/features/event/personal/screens/create_event_screen.dart';
import 'package:qr_ksa/features/event/personal/screens/payment_screen.dart';
import 'package:qr_ksa/features/event/public/screens/create_company_event_screen.dart';
import 'package:qr_ksa/features/home/screens/plans_screen.dart';

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
      case '/attendance-list':
        return MaterialPageRoute(builder: (_) => AttendanceListScreen());
      case '/create-event':
        return MaterialPageRoute(builder: (_) => const CreateEventScreen());

      case '/profile':
        return MaterialPageRoute(builder: (_) => const EventSecurityScreen());
      case '/otp':
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(phoneNumber: ''),
        );
      case '/login-event-security':
        return MaterialPageRoute(
          builder: (_) => const LoginEventSecurityScreen(),
        );
      case '/event-security-dashboard':
        return MaterialPageRoute(builder: (_) => const EventSecurityScreen());
      case '/create-company-event':
        return MaterialPageRoute(
          builder: (_) => const CreateCompanyEventScreen(),
        );
      case '/plans':
        return MaterialPageRoute(
          builder: (_) => const PlansScreen(planType: null),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('الصفحة غير موجودة!'))),
        );
    }
  }
}
