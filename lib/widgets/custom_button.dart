import 'package:flutter/material.dart';
import '../core/constants.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    // محتوى الزر (الأيقونة + النص)
    Widget child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Icon(
            icon,
            color: isOutlined ? AppColors.primary : Colors.white,
            size: 21,
          ),
        if (icon != null) const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isOutlined ? AppColors.primary : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
            letterSpacing: 1,
          ),
        ),
      ],
    );

    if (isOutlined) {
      // Outlined button مع حدود متدرجة
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            // الطبقة الأولى: حدود متدرجة
            gradient: AppColors.primaryGradient,
          ),
          padding: const EdgeInsets.all(2), // سماكة الحد المتدرج
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              // الطبقة الثانية: خلفية الزر (أبيض أو خلفية شفافة)
              // ممكن تغيرها حسب ما تحب
              color: AppColors.background,
            ),
            child: child,
          ),
        ),
      );
    } else {
      // زر عادي (ممتلئ متدرج)
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.13),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      );
    }
  }
}
