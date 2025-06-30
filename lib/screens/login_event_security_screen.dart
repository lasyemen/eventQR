import 'package:flutter/material.dart';
import '../core/constants.dart'; // يجب أن يحتوي على AppColors

class LoginEventSecurityScreen extends StatefulWidget {
  const LoginEventSecurityScreen({Key? key}) : super(key: key);

  @override
  State<LoginEventSecurityScreen> createState() =>
      _LoginEventSecurityScreenState();
}

class _LoginEventSecurityScreenState extends State<LoginEventSecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNumberController = TextEditingController();
  final TextEditingController _eventCodeController = TextEditingController();

  String? _errorMessage;

  void _login() {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      // تحقق وهمي فقط
      if (_eventNumberController.text != "123" ||
          _eventCodeController.text != "0000") {
        setState(() {
          _errorMessage = "رقم الفعالية أو رمز الدخول غير صحيح";
        });
      } else {
        // الانتقال للداشبورد الأمني
        Navigator.pushReplacementNamed(context, '/event-security-dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            automaticallyImplyLeading: false, // لا تظهر سهم الرجوع الافتراضي
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.primary),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios, // السهم متجه لليسار مع RTL
                  color: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                tooltip: 'رجوع',
              ),
            ],
            title: Text(
              'دخول أمن الفعالية',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 54,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'أدخل رقم الفعالية ورمز الدخول الأمني',
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // رقم الفعالية
                      TextFormField(
                        controller: _eventNumberController,
                        style: TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText: 'رقم الفعالية',
                          labelStyle: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          filled: true,
                          fillColor: AppColors.inputFill,
                          prefixIcon: Icon(
                            Icons.numbers,
                            color: AppColors.primary,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'يرجى إدخال رقم الفعالية';
                          if (value.length < 3) return 'رقم الفعالية غير صالح';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // رمز الدخول
                      TextFormField(
                        controller: _eventCodeController,
                        style: TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText: 'رمز الدخول',
                          labelStyle: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          filled: true,
                          fillColor: AppColors.inputFill,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: AppColors.primary,
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'يرجى إدخال رمز الدخول';
                          if (value.length < 4) return 'رمز الدخول غير صالح';
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),

                      if (_errorMessage != null)
                        Column(
                          children: [
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'دخول',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
