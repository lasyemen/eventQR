import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants.dart';
import '../../../core/contacts_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions(); // اطلب الصلاحيات هنا!
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await ContactsService.requestContactsPermission();
    // يمكنك أيضاً طلب صلاحية الصور لو تحتاج:
    // await Permission.photos.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              padding: const EdgeInsets.all(28),
              child: Icon(
                Icons.qr_code_2_rounded,
                size: 56,
                color: AppColors.background,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'دعوة QR',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'سهولة، أمان، تنظيم.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 90),
            CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
