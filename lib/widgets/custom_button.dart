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
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: isOutlined
          ? OutlinedButton.icon(
              icon: icon != null
                  ? Icon(icon, color: AppColors.primary)
                  : SizedBox.shrink(),
              label: Text(
                label,
                style: TextStyle(color: AppColors.primary, fontSize: 18),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: AppColors.background,
              ),
              onPressed: onPressed,
            )
          : ElevatedButton.icon(
              icon: icon != null
                  ? Icon(icon, color: AppColors.background)
                  : SizedBox.shrink(),
              label: Text(
                label,
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              onPressed: onPressed,
            ),
    );
  }
}
