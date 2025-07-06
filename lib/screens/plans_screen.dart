// lib/screens/plans_screen.dart

import 'package:flutter/material.dart';
import '../core/constants.dart'; // AppColors.primaryGradient
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Screen to display both personal and corporate subscription plans
class PlansScreen extends StatelessWidget {
  const PlansScreen({Key? key, required this.planType}) : super(key: key);

  final String? planType;

  @override
  Widget build(BuildContext context) {
    final Gradient mainGradient = AppColors.primaryGradient;

    Widget buildPersonalCard({
      required String title,
      required String price,
      required List<String> features,
    }) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            gradient: mainGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              ...features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      const Icon(
                        FontAwesomeIcons.checkCircle,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // ← button is now white
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: mainGradient.colors[0].withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(-2, -2),
                        ),
                        BoxShadow(
                          color: mainGradient.colors[3].withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // TODO: Hook up purchase flow
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Text(
                            'اشترك',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              // use your gradient’s last color so it shows up on white
                              color: mainGradient.colors.last,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget buildCorporateCard({
      required String title,
      required String price,
      required List<String> features,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: mainGradient.colors[0].withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(-2, -2),
            ),
            BoxShadow(
              color: mainGradient.colors[3].withOpacity(0.9),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      FontAwesomeIcons.checkCircle,
                      size: 14,
                      color: mainGradient.colors.last,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: mainGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // TODO: Hook up purchase flow
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Text(
                          'اشترك',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: ShaderMask(
            shaderCallback: (bounds) => mainGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            blendMode: BlendMode.srcIn,
            child: const Text(
              'خطط الاشتراك',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'للأفراد',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            buildPersonalCard(
              title: 'خطة الأفراد',
              price: '300 ريال/شهر',
              features: [
                'الاحتفال بأعياد الميلاد',
                'خاص للأصدقاء—لا يُعلن للجمهور',
                'إرسال QR عبر واتساب',
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'للشركات والمؤسسات',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
            buildCorporateCard(
              title: 'خطة الشركات',
              price: '٥٠٠ ريال/شهر',
              features: [
                'إعلان الفعاليات للجمهور',
                'إدارة الحضور وتقارير',
                'دعم متعدد المستخدمين',
                'تحليلات متقدمة',
              ],
            ),
          ],
        ),
      ),
    );
  }
}
