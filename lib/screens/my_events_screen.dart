// lib/screens/my_events_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_ksa/core/constants.dart';

class MyEventsScreen extends StatelessWidget {
  final List<Map<String, String>> events;
  const MyEventsScreen({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Gradient mainGradient = AppColors.primaryGradient;

    return DefaultTextStyle(
      style: const TextStyle(fontFamily: 'Rubik'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // or whatever background you prefer
          elevation: 0,
          centerTitle: true, // optional, if you want it centered
          title: ShaderMask(
            shaderCallback: (bounds) => mainGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            blendMode: BlendMode.srcIn,
            child: const Text(
              'جميع فعالياتي',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // this color is replaced by the gradient
              ),
            ),
          ),
        ),

        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (ctx, i) {
            final ev = events[i];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: mainGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  // Move the arrow to the left by using `leading`
                  leading: ShaderMask(
                    shaderCallback: (bounds) => mainGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    blendMode: BlendMode.srcIn,
                    child: const FaIcon(FontAwesomeIcons.chevronLeft),
                  ),
                  title: Text(
                    ev['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  subtitle: Text(
                    '${ev['date']} - ${ev['location']}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {},
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
