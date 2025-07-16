import 'package:flutter/material.dart';
import 'send_invitation_screen.dart';
import '../core/constants.dart';
import '../widgets/custom_button.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:intl/intl.dart';
import 'payment_screen.dart';
import 'organizer_payment_screen.dart';

class EventReviewScreen extends StatelessWidget {
  final Map<String, dynamic> eventData;
  final List attendees;
  const EventReviewScreen({
    Key? key,
    required this.eventData,
    required this.attendees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          blendMode: BlendMode.srcIn,
          child: const Text(
            'مراجعة الفعالية',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'Rubik',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    eventData['imagePath'] != null &&
                            eventData['imagePath'].toString().isNotEmpty
                        ? Image.file(
                            File(eventData['imagePath']),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image,
                              size: 64,
                              color: Colors.grey,
                            ),
                          ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Location at top right
                    if ((eventData['location'] ?? '').toString().isNotEmpty)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              eventData['location'],
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 11,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    // Capacity at bottom left
                    if ((eventData['capacity'] ?? '').toString().isNotEmpty)
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'عدد الأشخاص: ${eventData['capacity']}',
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Title, date, and time at bottom right
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventData['eventName'] ?? '-',
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Builder(
                            builder: (context) {
                              String dateStr = '';
                              String timeStr = '';
                              if (eventData['dateTime'] != null &&
                                  eventData['dateTime'].toString().isNotEmpty) {
                                try {
                                  final dt = DateTime.parse(
                                    eventData['dateTime'],
                                  );
                                  dateStr = DateFormat(
                                    'yyyy/MM/dd',
                                    'ar',
                                  ).format(dt);
                                  timeStr = DateFormat(
                                    'HH:mm',
                                    'ar',
                                  ).format(dt);
                                } catch (_) {
                                  dateStr = eventData['dateTime'].toString();
                                }
                              }
                              return Row(
                                children: [
                                  if (dateStr.isNotEmpty) ...[
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      dateStr,
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                  if (timeStr.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      timeStr,
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: attendees.length,
                itemBuilder: (context, idx) {
                  final attendee = attendees[idx];
                  final name = attendee.displayName ?? attendee.toString();
                  final phone =
                      (attendee.phones != null && attendee.phones.isNotEmpty)
                      ? attendee.phones.first.number
                      : '';
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(name),
                    subtitle: Text(phone),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'الدفع وتفعيل الفعالية',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        OrganizerPaymentScreen(eventData: eventData),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Add the gradient outline painter for the card
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

// Update _InfoRow for modern value style
class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontFamily: 'Rubik',
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Text(
            value ?? '-',
            style: const TextStyle(
              color: Colors.black87,
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              height: 1.4,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
