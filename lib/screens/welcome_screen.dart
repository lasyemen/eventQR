import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // لوجو أو أيقونة QR
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  padding: const EdgeInsets.all(30),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 50,
                    color: AppColors.background,
                  ),
                ),
                const SizedBox(height: 40),
                // اسم التطبيق
                Text(
                  'دعوة QR',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'أرسل دعواتك بذكاء وسهولة.',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 50),

                // زر تسجيل دخول
                CustomButton(
                  label: 'تسجيل دخول',
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                const SizedBox(height: 18),

                // زر إنشاء حساب
                CustomButton(
                  label: 'إنشاء حساب جديد',
                  isOutlined: true,
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
                const SizedBox(height: 18),

                // زر أمني فعالية
                CustomButton(
                  label: 'أمني فعالية',
                  icon: Icons.verified_user,
                  onPressed: () {
                    Navigator.pushNamed(context, '/login-event-security');
                  },
                ),
                const SizedBox(height: 60),

                // حقوق أو نص سفلي صغير
                Text(
                  'كل الحقوق محفوظة © ${DateTime.now().year}',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
