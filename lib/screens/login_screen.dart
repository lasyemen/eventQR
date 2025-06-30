import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  String _phone = '';
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..forward();
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال رمز التحقق بنجاح!')),
        );
        Navigator.pushReplacementNamed(
          context,
          '/otp',
          arguments: {'phoneNumber': '+966$_phone'},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // لوجو أو أيقونة مع أنيميشن
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.11),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.11),
                                blurRadius: 22,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.qr_code_2_rounded,
                              color: AppColors.primary,
                              size: 38,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'أهلًا بك 👋',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Tajawal',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'سجّل دخولك برقم جوالك السعودي',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            setState(() {});
                          },
                          child: TextFormField(
                            focusNode: _focusNode,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(9),
                            ],
                            style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 1.7,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'رقم الجوال',
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15.5,
                              ),
                              hintText: 'مثال: 512345678',
                              hintStyle: TextStyle(
                                color: Colors.grey[350],
                                fontSize: 15,
                              ),
                              suffixIcon: Container(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 10,
                                  start: 2,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.flag_circle_rounded,
                                      color: Color(0xFF198754),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '+966',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.08),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1.3,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: _focusNode.hasFocus
                                      ? AppColors.primary.withOpacity(0.30)
                                      : Colors.grey.shade200,
                                  width: 1.1,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              final pattern = r'^(5\d{8})$';
                              final regExp = RegExp(pattern);
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال رقم الجوال';
                              } else if (!regExp.hasMatch(value)) {
                                return 'أدخل رقم جوال سعودي صحيح (5XXXXXXXX)';
                              }
                              return null;
                            },
                            onSaved: (value) => _phone = value!,
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                label: 'دخول',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _login();
                                  }
                                },
                              ),
                            ),
                      const SizedBox(height: 22),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            // Navigator.pushNamed(context, '/privacy');
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'بالدخول أنت توافق على ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                              children: [
                                TextSpan(
                                  text: 'سياسة الخصوصية والشروط',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.flag,
                            color: Color(0xFF198754),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'تطبيق سعودي 🇸🇦',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'كل الحقوق محفوظة © ${DateTime.now().year}',
                        style: TextStyle(
                          color: Colors.grey[350],
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // زر الرجوع أعلى يمين الشاشة (RTL)
            Positioned(
              top: 32,
              right: isRtl ? 18 : null,
              left: isRtl ? null : 18,
              child: ClipOval(
                child: Material(
                  color: Colors.white.withOpacity(0.94),
                  child: InkWell(
                    splashColor: AppColors.primary.withOpacity(0.18),
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacementNamed('/welcome');
                      }
                    },
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black87,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
