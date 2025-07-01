import 'package:flutter/material.dart';

class AppColors {
  // Canva-inspired gradient (teal to royal blue)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00C4CC), // Canva Teal
      Color(0xFF009AC9), // Canva Light Blue
      Color(0xFF005EAA), // Canva Dark Blue
      Color(0xFF253B9B), // Deep Indigo
    ],
  );

  // Single primary color fallback (first gradient stop)
  static const Color primary = Color(0xFF00C4CC);

  // Additional purple-themed palette
  static const Color background = Color(0xFFF3E5F5);
  static const Color accent = Color(0xFFD291BC);
  static const Color border = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF4A148C);
  static const Color inputFill = Color(0xFFF8F0FA);
}

const eventTypes = [
  "زواج",
  "تخرج",
  "عزيمة",
  "اجتماع عمل",
  "حفل عيد ميلاد",
  "عقيقة",
  "اجتماع عائلي",
  "مناسبة أخرى",
];
