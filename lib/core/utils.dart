import 'package:flutter/material.dart';
import 'package:qr_ksa/core/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
}

SupabaseClient get supabase => Supabase.instance.client;

void showCustomSnackbar(BuildContext context, String message, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: AppColors.background)),
      backgroundColor: color ?? AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// يمكنك إضافة دوال مساعدة هنا مثل التحقق من رقم الهاتف أو البريد أو النسخ إلى الحافظة
