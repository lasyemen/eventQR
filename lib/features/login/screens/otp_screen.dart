import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants.dart';
import '../../../widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final int length = 6;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  final List<FocusNode> _listenerFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _controllers.addAll(List.generate(length, (_) => TextEditingController()));
    _focusNodes.addAll(List.generate(length, (_) => FocusNode()));
    _listenerFocusNodes.addAll(List.generate(length, (_) => FocusNode()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    for (final f in _listenerFocusNodes) f.dispose();
    super.dispose();
  }

  String get otp => _controllers.map((c) => c.text).join();

  void _onChanged(int idx, String value) {
    if (value.length > 1) {
      String clean = value.replaceAll(RegExp(r'[^0-9]'), '');
      for (int i = 0; i < length; i++) {
        _controllers[i].text = i < clean.length ? clean[i] : '';
      }
      FocusScope.of(context).unfocus();
      setState(() {});
      return;
    }
    if (value.isNotEmpty && idx < length - 1) {
      _focusNodes[idx + 1].requestFocus();
    } else if (value.isEmpty && idx > 0) {
      _focusNodes[idx - 1].requestFocus();
    }
    setState(() {});
  }

  void _verifyOtp() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _clearAll() {
    for (final c in _controllers) c.clear();
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
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
    final theme = Theme.of(context);
    final Color softBox = AppColors.primary.withOpacity(0.06);
    final Color borderSoft = AppColors.primary.withOpacity(0.16);

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 54,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 18),
                Text(
                  'أدخل رمز التحقق المرسل إلى',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.phoneNumber,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 34),
                SizedBox(
                  height: 65,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(length, (idx) {
                        final isFocused = _focusNodes[idx].hasFocus;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 210),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 50,
                          height: 60,
                          decoration: BoxDecoration(
                            color: softBox,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isFocused ? AppColors.primary : borderSoft,
                              width: isFocused ? 1.7 : 1.1,
                            ),
                            boxShadow: [
                              if (isFocused)
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.10),
                                  blurRadius: 13,
                                  spreadRadius: 0.4,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: Center(
                            child: RawKeyboardListener(
                              focusNode: _listenerFocusNodes[idx],
                              onKey: (RawKeyEvent event) {
                                if (event is RawKeyDownEvent &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.backspace &&
                                    _controllers[idx].text.isEmpty &&
                                    idx > 0) {
                                  _focusNodes[idx - 1].requestFocus();
                                  _controllers[idx - 1].clear();
                                  setState(() {});
                                }
                              },
                              child: TextField(
                                controller: _controllers[idx],
                                focusNode: _focusNodes[idx],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 1,
                                  fontFamily: 'Rubik',
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                showCursor: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                  contentPadding: EdgeInsets.zero,
                                  fillColor: Colors.transparent,
                                  filled: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (val) => _onChanged(idx, val),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                CustomButton(
                  label: 'تحقق',
                  onPressed: _verifyOtp, // <-- ينقلك للهوم مباشرة دائماً
                  icon: Icons.verified,
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.accent,
                    size: 21,
                  ),
                  label: Text(
                    'إعادة إرسال الرمز',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _resendCode,
                ),
                TextButton(
                  onPressed: _clearAll,
                  child: Text(
                    'مسح الكل',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color.fromARGB(255, 52, 55, 57),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
