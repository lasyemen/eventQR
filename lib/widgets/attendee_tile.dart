import 'package:flutter/material.dart';
import '../core/constants.dart';

class AttendeeTile extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback? onSend;
  final Widget? trailing;

  const AttendeeTile({
    Key? key,
    required this.name,
    required this.phone,
    this.onSend,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, color: AppColors.background),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        subtitle: Text(phone, style: TextStyle(color: AppColors.accent)),
        trailing:
            trailing ??
            (onSend != null
                ? IconButton(
                    icon: Icon(Icons.send, color: AppColors.primary),
                    onPressed: onSend,
                  )
                : null),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      ),
    );
  }
}
