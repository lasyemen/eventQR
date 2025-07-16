import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/signup/signup_bloc.dart';
import '../bloc/signup/signup_event.dart';
import '../bloc/signup/signup_state.dart';
import '../core/constants.dart';
import '../widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  final _nameController = TextEditingController();
  late final SignupBloc _signupBloc;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _signupBloc = SignupBloc();
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
    _nameController.dispose();
    _focusNode.dispose();
    _signupBloc.close();
    super.dispose();
  }

  void _onSignupSubmitted(String phone) {
    _signupBloc.add(SignupSubmitted(name: _nameController.text, phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return BlocProvider(
      create: (context) => _signupBloc,
      child: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إرسال رمز التحقق بنجاح!')),
            );
            Navigator.pushReplacementNamed(
              context,
              '/otp',
              arguments: {'phoneNumber': '+966${state.phone}'},
            );
          } else if (state.status == SignupStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'لم يتم الحفظ!')),
            );
          }
        },
        child: Scaffold(
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
                              child: const Icon(
                                Icons.person_add_outlined,
                                color: AppColors.primary,
                                size: 38,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'إنشاء حساب جديد 👋',
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
                            'أدخل بياناتك لإنشاء حساب جديد',
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
                            child: TextFormField(
                              controller: _nameController,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                labelText: 'الاسم الكامل',
                                labelStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15.5,
                                ),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Colors.grey[400],
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
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 1.1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.3,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى إدخال الاسم الكامل';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
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
                                      color: AppColors.primary.withOpacity(
                                        0.08,
                                      ),
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
                                onSaved: (value) =>
                                    context.read<SignupBloc>().add(
                                      SignupSubmitted(
                                        name: _nameController.text,
                                        phone: value!,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 34),
                          BlocBuilder<SignupBloc, SignupState>(
                            builder: (context, state) {
                              return state.status == SignupStatus.loading
                                  ? const CircularProgressIndicator()
                                  : SizedBox(
                                      width: double.infinity,
                                      child: CustomButton(
                                        label: 'إنشاء حساب',
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            _onSignupSubmitted(state.phone);
                                          }
                                        },
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    return state.status == SignupStatus.loading
                        ? Container(
                            color: Colors.black26,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
