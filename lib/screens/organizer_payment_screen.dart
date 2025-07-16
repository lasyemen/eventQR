import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import 'payment_success_screen.dart';

class OrganizerPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;
  const OrganizerPaymentScreen({Key? key, required this.eventData})
    : super(key: key);

  @override
  State<OrganizerPaymentScreen> createState() => _OrganizerPaymentScreenState();
}

class _OrganizerPaymentScreenState extends State<OrganizerPaymentScreen> {
  String _selectedPayment = 'mada';

  @override
  Widget build(BuildContext context) {
    final event = widget.eventData;
    String dateStr = '';
    if (event['dateTime'] != null && event['dateTime'].toString().isNotEmpty) {
      try {
        final dt = DateTime.parse(event['dateTime']);
        dateStr = DateFormat('yyyy/MM/dd - HH:mm', 'ar').format(dt);
      } catch (_) {
        dateStr = event['dateTime'].toString();
      }
    }
    final location = event['location'] ?? '';
    final eventName = event['eventName'] ?? '-';
    // For demo, set a static price/plan
    final String planName = 'الخطة الأساسية';
    final String price = '299 ريال';

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          blendMode: BlendMode.srcIn,
          child: const Text(
            'الدفع وتفعيل الفعالية',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white, // replaced by gradient
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gradient outlined info card with shadow
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGradient.colors.first.withOpacity(
                      0.08,
                    ),
                    blurRadius: 6,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _GradientOutlinePainter(
                  borderRadius: 16,
                  strokeWidth: 2,
                  gradient: AppColors.primaryGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.event,
                            color: Colors.black54,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              eventName,
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.black54,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateStr,
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      if (location.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black54,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                location,
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28), // more space after info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGradient.colors.last.withOpacity(
                      0.08,
                    ),
                    blurRadius: 6,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    planName,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32), // more space after plan card
            const Text(
              'اختر طريقة الدفع:',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 18), // more space before payment methods
            // Gradient radio buttons
            _GradientRadioTile(
              value: 'mada',
              groupValue: _selectedPayment,
              onChanged: (val) => setState(() => _selectedPayment = val!),
              label: 'مدى',
            ),
            const SizedBox(height: 10),
            _GradientRadioTile(
              value: 'stc',
              groupValue: _selectedPayment,
              onChanged: (val) => setState(() => _selectedPayment = val!),
              label: 'STC Pay',
            ),
            const SizedBox(height: 10),
            _GradientRadioTile(
              value: 'visa',
              groupValue: _selectedPayment,
              onChanged: (val) => setState(() => _selectedPayment = val!),
              label: 'Visa / Mastercard',
            ),
            const Spacer(),
            const SizedBox(height: 24), // more space above button
            // Gradient filled button
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGradient.colors.first.withOpacity(
                        0.08,
                      ),
                      blurRadius: 6,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Simulate payment success
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentSuccessScreen(eventData: event),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'دفع وتفعيل الفعالية',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Gradient outline painter for info card
class _GradientOutlinePainter extends CustomPainter {
  final double borderRadius;
  final double strokeWidth;
  final Gradient gradient;
  _GradientOutlinePainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.gradient,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Gradient radio tile
class _GradientRadioTile extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final String label;
  const _GradientRadioTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryGradient.colors.first
                      : Colors.grey[400]!,
                  width: 2.2,
                ),
                gradient: selected ? AppColors.primaryGradient : null,
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
                color: selected
                    ? AppColors.primaryGradient.colors.first
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
