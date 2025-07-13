import 'package:flutter/material.dart';
import 'send_invitation_screen.dart';

class EventReviewScreen extends StatelessWidget {
  const EventReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تفاصيل الفعالية ستُعرض هنا
    return Scaffold(
      appBar: AppBar(title: const Text('مراجعة الفعالية')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            title: Text('اسم الفعالية: مثال'),
            subtitle: Text('التاريخ: 2025-07-09\nالمكان: جدة'),
          ),
          // عرض الحضور وطريقة الدفع وغير ذلك...
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SendInvitationScreen()),
              );
            },
            child: const Text('إرسال الدعوة'),
          ),
        ],
      ),
    );
  }
}
