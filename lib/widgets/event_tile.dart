import 'package:flutter/material.dart';
import '../core/constants.dart';

class EventTile extends StatelessWidget {
  final String eventName;
  final String date;
  final VoidCallback? onTap;

  const EventTile({
    Key? key,
    required this.eventName,
    required this.date,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        title: Text(
          eventName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
        subtitle: Text(date, style: TextStyle(color: Colors.grey.shade600)),
        trailing: Icon(Icons.chevron_right, color: AppColors.primary),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      ),
    );
  }
}
