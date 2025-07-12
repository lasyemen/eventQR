import 'package:flutter/material.dart';
import 'package:qr_ksa/screens/event_security_screen.dart';
import 'package:qr_ksa/screens/home_screen.dart';
import 'package:qr_ksa/screens/login_event_security_screen.dart';
import 'package:qr_ksa/screens/otp_screen.dart';
import 'package:qr_ksa/screens/scan_qr_screen.dart';
import 'package:qr_ksa/screens/splash_screen.dart';
import 'package:qr_ksa/screens/welcome_screen.dart';
import 'package:qr_ksa/screens/login_screen.dart';
import 'package:qr_ksa/screens/signup_screen.dart';
import 'package:qr_ksa/screens/attendance_list_screen.dart';
import 'package:qr_ksa/screens/create_event_screen.dart';
import 'package:qr_ksa/screens/payment_screen.dart'; // <-- استيراد شاشة الدفع الجديد

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
      case '/payment': // <-- مسار شاشة الدفع
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
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
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('الصفحة غير موجودة!'))),
        );
    }
  }
}
