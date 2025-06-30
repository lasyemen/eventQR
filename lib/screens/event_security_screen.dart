import 'package:flutter/material.dart';
import 'scan_qr_screen.dart'; // عدّل المسار إذا كان الملف في مجلد آخر

class EventSecurityScreen extends StatelessWidget {
  const EventSecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text(
          'أمان الفعالية',
          style: TextStyle(color: Color(0xFF222B45)),
        ),
        backgroundColor: const Color(0xFFF6F8FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF33BDC2)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SecurityCard(
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
            const SizedBox(height: 20),
            _SecurityCard(
              icon: Icons.group,
              title: 'قائمة الحضور',
              subtitle: 'عرض جميع الأشخاص المسموح لهم بالدخول',
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _SecurityCard(
              icon: Icons.shield,
              title: 'إجراءات أمان إضافية',
              subtitle: 'إعدادات وتوصيات لتعزيز الأمان أثناء الفعالية',
              onTap: () {},
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33BDC2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(
                  Icons.report_gmailerrorred_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'إبلاغ عن مشكلة أمنية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // TODO: فعل إرسال بلاغ دعم فني أو نافذة حوار
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SecurityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E5EB)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFD6F2F3),
              radius: 24,
              child: Icon(icon, color: const Color(0xFF33BDC2), size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bold QR في العنوان
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: title.split(' ')[0] + ' ',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: title.split(' ').sublist(1).join(' '),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFBDC3C7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
