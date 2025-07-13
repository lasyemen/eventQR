import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart'; // لـ AppColors.primaryGradient
import 'scan_qr_screen.dart';
// **لا تستورد attendance_list_screen هنا**

class EventSecurityScreen extends StatelessWidget {
  const EventSecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainGradient = AppColors.primaryGradient;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF33BDC2)),
          title: ShaderMask(
            shaderCallback: (bounds) => mainGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            blendMode: BlendMode.srcIn,
            child: const Text(
              'أمان الفعالية',
              style: TextStyle(
                fontFamily: 'Rubik',
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // كرت تفعيل تحقق QR
              _SecurityCard(
                gradient: mainGradient,
                icon: Icons.qr_code_scanner,
                title: 'تفعيل تحقق QR',
                subtitle: 'تأكد من دخول الحضور عبر رمز QR الخاص بهم',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScanQRScreen()),
                  );
                },
              ),
              const SizedBox(height: 18),
              // كرت قائمة الحضور عبر الراوتر
              _SecurityCard(
                gradient: mainGradient,
                icon: Icons.group,
                title: 'قائمة الحضور',
                subtitle: 'عرض جميع الأشخاص المسموح لهم بالدخول',
                onTap: () {
                  Navigator.pushNamed(context, '/attendance-list');
                },
              ),
              const SizedBox(height: 18),
              _SecurityCard(
                gradient: mainGradient,
                icon: Icons.shield,
                title: 'إجراءات أمان إضافية',
                subtitle: 'إعدادات وتوصيات لتعزيز الأمان أثناء الفعالية',
                onTap: () {},
              ),
              const SizedBox(height: 26),
              // زر الإبلاغ عن مشكلة
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: mainGradient.colors[0].withOpacity(0.12),
                      blurRadius: 7,
                      offset: const Offset(-2, -2),
                    ),
                    BoxShadow(
                      color: mainGradient.colors.last.withOpacity(0.18),
                      blurRadius: 7,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'الإبلاغ عن مشكلة أمنية',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'في حال واجهتك مشكلة أمنية أثناء الفعالية، تواصل مع الدعم فوراً',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: mainGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // TODO: فعل الإبلاغ أو نافذة دعم
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.report_gmailerrorred_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SecurityCard({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.18),
            radius: 26,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 17,
            ),
            textAlign: TextAlign.right,
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Rubik',
              color: Colors.white70,
              fontSize: 13,
            ),
            textAlign: TextAlign.right,
          ),
          trailing: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white70,
            size: 20,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
