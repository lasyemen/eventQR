import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import '../widgets/custom_button.dart';
import 'package:qr_ksa/screens/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final Function(String otp)? onVerify;

  const OtpScreen({Key? key, required this.phoneNumber, this.onVerify})
    : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool isLoading = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get otp => _controllers.map((c) => c.text).join();

  void _onChanged(int idx, String value) {
    if (value.isNotEmpty && !RegExp(r'^\d\$').hasMatch(value)) {
      _controllers[idx].clear();
      return;
    }
    if (value.length > 1 && value.length == 6) {
      for (var i = 0; i < 6; i++) _controllers[i].text = value[i];
      FocusScope.of(context).unfocus();
      setState(() {});
      return;
    }
    if (value.length == 1 && idx < 5) {
      _focusNodes[idx + 1].requestFocus();
    }
    setState(() {});
  }

  void _handleKeyEvent(int idx, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[idx].text.isEmpty && idx > 0) {
        _focusNodes[idx - 1].requestFocus();
        _controllers[idx - 1].clear();
      }
    }
  }

  void _verifyOtp() {
    // Navigate directly to HomeScreen
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  void _clearAll() {
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
    setState(() {});
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تمت إعادة إرسال الرمز بنجاح!'),
        backgroundColor: AppColors.primary,
      ),
    );
    _clearAll();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final otpBoxWidth = screenWidth > 420
        ? 52.0
        : screenWidth > 360
        ? 45.0
        : 37.0;
    final otpBoxSpace = screenWidth > 420
        ? 12.0
        : screenWidth > 360
        ? 8.0
        : 6.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'رمز التحقق',
          style: TextStyle(color: AppColors.text),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 54, color: AppColors.primary),
              const SizedBox(height: 14),
              Text(
                'أدخل رمز التحقق المرسل إلى',
                style: TextStyle(fontSize: 18, color: AppColors.text),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 7),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 26),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (idx) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: otpBoxSpace / 2,
                      ),
                      child: SizedBox(
                        width: otpBoxWidth,
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (event) => _handleKeyEvent(idx, event),
                          child: TextField(
                            controller: _controllers[idx],
                            focusNode: _focusNodes[idx],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: AppColors.inputFill,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 13,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1.1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (val) => _onChanged(idx, val),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 18),
              CustomButton(label: 'تحقق', onPressed: _verifyOtp),
              const SizedBox(height: 20),
              TextButton.icon(
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.accent,
                  size: 21,
                ),
                label: Text(
                  'إعادة إرسال الرمز',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                onPressed: _resendCode,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _clearAll,
                child: Text(
                  'مسح الكل',
                  style: TextStyle(color: AppColors.border, fontSize: 15),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
