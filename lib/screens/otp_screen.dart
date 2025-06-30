import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/custom_button.dart';
import 'package:flutter/services.dart';

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
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get otp => _controllers.map((controller) => controller.text).join();

  void _onChanged(int idx, String value) {
    if (value.isNotEmpty && !RegExp(r'^\d$').hasMatch(value)) {
      _controllers[idx].clear();
      return;
    }
    // لصق الكود دفعة واحدة (6 أرقام)
    if (value.length > 1 && value.length == 6) {
      for (var i = 0; i < 6; i++) {
        _controllers[i].text = value[i];
      }
      FocusScope.of(context).unfocus();
      setState(() {});
      return;
    }
    // التنقل بين الحقول تلقائياً
    if (value.length == 1 && idx < 5) {
      _focusNodes[idx + 1].requestFocus();
    }
    setState(() {});
  }

  void _handleKeyEvent(int idx, RawKeyEvent event) {
    // ignore: avoid_print
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      // إذا الحقل الحالي فاضي نرجع للي قبله ونفرغه
      if (_controllers[idx].text.isEmpty && idx > 0) {
        _focusNodes[idx - 1].requestFocus();
        _controllers[idx - 1].clear();
        setState(() {});
      }
    }
  }

  void _verifyOtp() {
    if (otp.length != 6 || otp.contains('')) {
      setState(() => errorText = 'أدخل جميع الأرقام الستة من رمز التحقق');
      return;
    }
    setState(() {
      isLoading = true;
      errorText = null;
    });
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => isLoading = false);
      if (widget.onVerify != null) {
        widget.onVerify!(otp);
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  void _clearAll() {
    for (final c in _controllers) {
      c.clear();
    }
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
                            onTap: () =>
                                _controllers[idx].selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _controllers[idx].text.length,
                                ),
                            onSubmitted: (val) {
                              if (idx == 5) {
                                FocusScope.of(context).unfocus();
                                _verifyOtp();
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 18),
              if (errorText != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.red[700], size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          errorText!,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              isLoading
                  ? const CircularProgressIndicator(color: AppColors.primary)
                  : CustomButton(label: 'تحقق', onPressed: _verifyOtp),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
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
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.accent,
                  ),
                  onPressed: _resendCode,
                ),
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
