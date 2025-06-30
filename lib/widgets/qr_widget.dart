import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../core/constants.dart';

class QrWidget extends StatelessWidget {
  final String data;
  final double size;

  const QrWidget({Key? key, required this.data, this.size = 150})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.border,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: size,
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.background,
        gapless: true,
      ),
    );
  }
}
