import 'package:flutter/material.dart';

class SendInvitationScreen extends StatelessWidget {
  const SendInvitationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إرسال الدعوة')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text('تم إرسال الدعوة بنجاح!'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}
