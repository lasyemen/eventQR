import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../widgets/custom_button.dart';

class LoginEventSecurityScreen extends StatefulWidget {
  const LoginEventSecurityScreen({Key? key}) : super(key: key);

  @override
  State<LoginEventSecurityScreen> createState() =>
      _LoginEventSecurityScreenState();
}

class _LoginEventSecurityScreenState extends State<LoginEventSecurityScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNumberController = TextEditingController();
  final TextEditingController _eventCodeController = TextEditingController();
  String? _errorMessage;
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
    _eventNumberController.dispose();
    _eventCodeController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() => _isLoading = false);

      if (_formKey.currentState!.validate()) {
        if (_eventNumberController.text != "123" ||
            _eventCodeController.text != "0000") {
          setState(() {
            _errorMessage = "رقم الفعالية أو رمز الدخول غير صحيح";
          });
        } else {
          Navigator.pushReplacementNamed(context, '/event-security-dashboard');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.primary),
          // عكس اتجاه زر الرجوع للجهة الثانية بشكل يدوي
          leading: Align(
            alignment: Alignment.centerLeft, // أقصى يسار الشاشة
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ), // سهم لليسار (معكوس في RTL)
              color: AppColors.primary,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                              color: AppColors.primary.withOpacity(0.10),
                              blurRadius: 22,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.verified_user,
                            color: AppColors.primary,
                            size: 38,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'دخول أمن الفعالية',
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
                      'أدخل رقم الفعالية ورمز الدخول الأمني',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _eventNumberController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        labelText: 'رقم الفعالية',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15.5,
                        ),
                        hintText: 'مثال: 123',
                        hintStyle: TextStyle(
                          color: Colors.grey[350],
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(
                          Icons.tag,
                          color: AppColors.primary,
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
                            color: Colors.grey.shade200,
                            width: 1.1,
                          ),
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
                    TextFormField(
                      controller: _eventCodeController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        labelText: 'رمز الفعالية',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15.5,
                        ),
                        hintText: 'مثال: 0000',
                        hintStyle: TextStyle(
                          color: Colors.grey[350],
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.primary,
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
                            color: Colors.grey.shade200,
                            width: 1.1,
                          ),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'يرجى إدخال رمز الفعالية';
                        if (value.length < 4) return 'رمز الفعالية غير صالح';
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              label: 'دخول',
                              icon: Icons.login,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                            ),
                          ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF198754),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'أمن الفعالية',
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
                      style: TextStyle(color: Colors.grey[350], fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
