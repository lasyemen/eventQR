import 'package:flutter/material.dart';
import 'event_review_screen.dart';

class PaymentScreen extends StatelessWidget {
  final Map<String, dynamic> eventData;
  final List attendees;
  const PaymentScreen({
    Key? key,
    required this.eventData,
    required this.attendees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String selectedPayment = 'mada';

    return Scaffold(
      appBar: AppBar(title: const Text('الدفع')),
      body: Column(
        children: [
          RadioListTile(
            value: 'mada',
            groupValue: selectedPayment,
            onChanged: (val) {},
            title: const Text('مدى'),
          ),
          RadioListTile(
            value: 'stc',
            groupValue: selectedPayment,
            onChanged: (val) {},
            title: const Text('STC Pay'),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventReviewScreen(
                    eventData: eventData,
                    attendees: attendees,
                  ),
                ),
              );
            },
            child: const Text('التالي: مراجعة التفاصيل'),
          ),
        ],
      ),
    );
  }
}
