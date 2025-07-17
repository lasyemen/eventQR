import 'package:flutter/material.dart';

class AttendanceListScreen extends StatelessWidget {
  // بيانات الحضور (تجريبية)
  final List<Map<String, String>> attendees = [
    {"name": "محمد أحمد", "status": "مسموح"},
    {"name": "علي صالح", "status": "مسموح"},
    {"name": "فاطمة عبدالله", "status": "مسموح"},
  ];

  AttendanceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // الهيدر العلوي (دون تعديل)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00C4CC), Color(0xFF005EAA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // زر الرجوع
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      // العنوان والنص
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'قائمة الحضور',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'عرض جميع الأشخاص المسموح لهم بالدخول',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      // أيقونة المجموعة
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        radius: 24,
                        child: Icon(
                          Icons.groups,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // قائمة الحضور
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: attendees.length,
                separatorBuilder: (_, __) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final attendee = attendees[index];
                  return ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    leading: Icon(
                      Icons.verified_user,
                      color: Color(0xFF00C4CC),
                    ),
                    // عكس اتجاه النصوص فقط هنا
                    title: Text(
                      attendee['name']!,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'الحالة: ${attendee['status']}',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
