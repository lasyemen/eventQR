import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:qr_ksa/core/constants.dart';
import 'package:qr_ksa/widgets/custom_button.dart';
import '../../personal/screens/select_attendees_screen.dart';
import 'event_review_screen.dart';

class EventCapacityScreen extends StatefulWidget {
  final Map<String, dynamic> eventInfo;
  final bool isPublicEvent;
  const EventCapacityScreen({
    Key? key,
    required this.eventInfo,
    this.isPublicEvent = false,
  }) : super(key: key);

  @override
  State<EventCapacityScreen> createState() => _EventCapacityScreenState();
}

class _EventCapacityScreenState extends State<EventCapacityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _ticketsController = TextEditingController();

  @override
  void dispose() {
    _capacityController.dispose();
    _ticketsController.dispose();
    super.dispose();
  }

  void _onNext() async {
    if (_formKey.currentState?.validate() ?? false) {
      final capacity = int.tryParse(_capacityController.text.trim()) ?? 0;
      final tickets = int.tryParse(_ticketsController.text.trim()) ?? 0;
      final eventData = {
        ...widget.eventInfo,
        'capacity': capacity,
        'tickets': tickets,
      };
      if (widget.isPublicEvent) {
        // Skip attendee selection for public events
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EventReviewScreen(eventData: eventData, attendees: const []),
          ),
        );
      } else {
        // Go to attendee selection for private/person events
        final attendees = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SelectAttendeesScreen()),
        );
        if (attendees != null && attendees is List) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  EventReviewScreen(eventData: eventData, attendees: attendees),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            blendMode: BlendMode.srcIn,
            child: const Text(
              'تحديد السعة والتذاكر',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'Rubik',
                color: Colors.white, // Will be replaced by gradient
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.only(right: 4, bottom: 6),
                    child: Text(
                      'كم عدد الأشخاص المسموح لهم بالحضور؟',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rubik',
                      ),
                    ),
                  ),
                  _ModernTextField(
                    controller: _capacityController,
                    label: 'عدد الأشخاص',
                    hint: 'مثال: 200',
                    icon: Icons.people,
                    validator: (val) {
                      final n = int.tryParse(val ?? '');
                      if (n == null || n <= 0) return 'أدخل رقمًا صحيحًا';
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  const Padding(
                    padding: EdgeInsets.only(right: 4, bottom: 6),
                    child: Text(
                      'كم عدد التذاكر المتاحة للبيع أو التوزيع؟',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rubik',
                      ),
                    ),
                  ),
                  _ModernTextField(
                    controller: _ticketsController,
                    label: 'عدد التذاكر',
                    hint: 'مثال: 150',
                    icon: Icons.confirmation_num,
                    validator: (val) {
                      final tickets = int.tryParse(val ?? '');
                      final capacity = int.tryParse(_capacityController.text);
                      if (tickets == null || tickets <= 0)
                        return 'أدخل رقمًا صحيحًا';
                      if (capacity != null && tickets > capacity)
                        return 'عدد التذاكر لا يمكن أن يتجاوز عدد الأشخاص';
                      return null;
                    },
                  ),
                  const SizedBox(height: 36),
                  CustomButton(label: 'التالي', onPressed: _onNext),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  const _ModernTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 6),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: _GradientOutlinePainter(
                  borderRadius: 18,
                  strokeWidth: 2,
                  gradient: AppColors.primaryGradient,
                ),
                child: const SizedBox.expand(),
              ),
              TextFormField(
                controller: controller,
                validator: validator,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13.5,
                  ),
                  prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
                style: const TextStyle(color: Colors.grey, fontSize: 13.5),
                textDirection: ui.TextDirection.rtl,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
