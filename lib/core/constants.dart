import 'package:flutter/material.dart';

class AppColors {
  //=======================//
  //       Gradients       //
  //=======================//
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00C4CC), // Teal
      Color(0xFF009AC9), // Light Blue
      Color(0xFF005EAA), // Dark Blue
      Color(0xFF253B9B), // Deep Indigo
    ],
  );

  //=======================//
  //    Brand & Primary    //
  //=======================//
  static const Color primary = Color(0xFF005EAA);
  static const Color primaryLight = Color(0xFF009AC9);
  static const Color primaryDark = Color(0xFF253B9B);
  static const Color accent = Color(0xFF00C4CC);
  static const Color secondary = Color(0xFF4FC3F7);

  //=======================//
  //    Backgrounds        //
  //=======================//
  static const Color background = Color(0xFFF7FBFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF23272E); // وضع ليلي

  //=======================//
  //        Texts          //
  //=======================//
  static const Color text = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF607D8B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFFB0BEC5);
  static const Color textDark = Color(0xFFF7FBFB); // نص على خلفية داكنة

  //=======================//
  //       Borders         //
  //=======================//
  static const Color border = Color(0xFFE3F2FD);

  //=======================//
  //        Inputs         //
  //=======================//
  static const Color inputFill = Color(0xFFF8F0FA);
  static const Color inputBorder = Color(0xFFB3E5FC);

  //=======================//
  //       States          //
  //=======================//
  static const Color success = Color(0xFF43A047);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA000);
  static const Color disabled = Color(0xFFB0BEC5);

  //=======================//
  //      Effects & UI     //
  //=======================//
  static const Color shadow = Color(0x3325374D); // ظل خفيف (20% شفافية)
  static const double elevation = 6;

  static var avatarBg; // افتراضي للبطاقات والأزرار
}

// الخطوط
class AppFonts {
  static const String header = 'Rubik';
  static const String body = 'Rubik';
}

// أنصاف الأقطار
class AppBorders {
  static const double radius = 14;
}
