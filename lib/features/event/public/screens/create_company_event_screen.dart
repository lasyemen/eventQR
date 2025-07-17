import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_ksa/core/constants.dart';
import 'package:qr_ksa/widgets/custom_button.dart';
import 'package:qr_ksa/core/utils.dart';
import 'package:qr_ksa/features/event/public/screens/event_capacity_screen.dart';

class CreateCompanyEventScreen extends StatefulWidget {
  static const routeName = '/create-company-event';
  const CreateCompanyEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateCompanyEventScreen> createState() =>
      _CreateCompanyEventScreenState();
}

class _CreateCompanyEventScreenState extends State<CreateCompanyEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  DateTime? _selectedDateTime;
  File? _eventImage;
  bool _isImageLoading = false;

  @override
  void dispose() {
    _orgNameController.dispose();
    _eventNameController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  // عزل ضغط الصورة في isolate
  static Future<dynamic> compressImageIsolate(
    Map<String, dynamic> params,
  ) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        params['path'],
        params['targetPath'],
        quality: params['quality'],
        minWidth: params['minWidth'],
        minHeight: params['minHeight'],
      );
      return result;
    } catch (_) {
      return null;
    }
  }

  // رفع الصورة إلى supabase storage
  Future<String?> _uploadImageToSupabase(File imageFile) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final response = await Supabase.instance.client.storage
          .from('images')
          .upload(fileName, imageFile);
      if (response.isEmpty) return null;
      final publicUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl(fileName);
      return publicUrl;
    } catch (e, st) {
      print('[uploadImageToSupabase] ERROR: $e\n$st');
      return null;
    }
  }

  // رفع بيانات الفعالية لقاعدة البيانات
  Future<bool> addCompanyEvent(Map<String, dynamic> event) async {
    try {
      await Supabase.instance.client
          .from('company_events')
          .insert(event)
          .select();
      return true;
    } catch (e) {
      print('Error inserting event: $e');
      return false;
    }
  }

  // Pick Image
  Future<void> _pickImage() async {
    setState(() => _isImageLoading = true);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (picked != null) {
        final docsDir = await getApplicationDocumentsDirectory();
        final targetPath =
            '${docsDir.path}/${DateTime.now().millisecondsSinceEpoch}_event.jpg';
        final compressed = await compute(compressImageIsolate, {
          'path': picked.path,
          'targetPath': targetPath,
          'quality': 60,
          'minWidth': 400,
          'minHeight': 250,
        });
        File? finalImage;
        if (compressed is File) {
          finalImage = compressed;
        } else if (compressed is XFile) {
          finalImage = File(compressed.path);
        } else {
          finalImage = File(picked.path);
        }
        setState(() {
          _eventImage = finalImage;
          _isImageLoading = false;
        });
        // رفع للصورة مباشرة بعد الاختيار
        if (finalImage != null) {
          final url = await _uploadImageToSupabase(finalImage);
          if (url != null && mounted) {
            showCustomSnackbar(context, 'تم رفع صورة الفعالية بنجاح');
          }
        }
      } else {
        setState(() => _isImageLoading = false);
      }
    } catch (e, st) {
      print('[pickImage] ERROR: $e\n$st');
      setState(() => _isImageLoading = false);
    }
  }

  // Pick Date & Time
  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    try {
      final date = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 5),
        locale: const Locale('ar'),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                surface: AppColors.surface,
                onSurface: AppColors.text,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: Builder(
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.primaryGradient.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          DateFormat('MMMM yyyy', 'ar').format(now),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Rubik',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: child!),
                  ],
                );
              },
            ),
          );
        },
      );
      if (date != null && context.mounted) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Theme(data: Theme.of(context), child: child!),
            );
          },
        );
        if (time != null) {
          setState(() {
            _selectedDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            _dateTimeController.text = DateFormat(
              'yyyy/MM/dd – HH:mm',
              'ar',
            ).format(_selectedDateTime!);
          });
        }
      }
    } catch (e) {
      // fallback
      final date = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 5),
      );
      if (date != null && context.mounted) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Theme(data: Theme.of(context), child: child!),
            );
          },
        );
        if (time != null) {
          setState(() {
            _selectedDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            _dateTimeController.text = DateFormat(
              'yyyy/MM/dd – HH:mm',
            ).format(_selectedDateTime!);
          });
        }
      }
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay(
              hour: _selectedDateTime!.hour,
              minute: _selectedDateTime!.minute,
            )
          : TimeOfDay.now(),
      builder: (context, child) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                surface: AppColors.surface,
                onSurface: AppColors.text,
              ),
              timePickerTheme: TimePickerThemeData(
                dialHandColor: AppColors.primary,
                dialBackgroundColor: AppColors.primaryGradient.colors.first
                    .withOpacity(0.08),
                hourMinuteColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.primaryGradient.colors.first,
                ),
                hourMinuteTextColor: Colors.white,
                dayPeriodColor: AppColors.primaryGradient.colors.last,
                dayPeriodTextColor: Colors.white,
                entryModeIconColor: AppColors.primary,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (_selectedDateTime != null) {
          _selectedDateTime = DateTime(
            _selectedDateTime!.year,
            _selectedDateTime!.month,
            _selectedDateTime!.day,
            picked.hour,
            picked.minute,
          );
        } else {
          final now = DateTime.now();
          _selectedDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            picked.hour,
            picked.minute,
          );
        }
        _dateTimeController.text = DateFormat(
          'yyyy/MM/dd – HH:mm',
          'ar',
        ).format(_selectedDateTime!);
      });
    }
  }

  // رفع البيانات عند الضغط على زر التالي
  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // تجهيز بيانات الفعالية
      final eventInfo = {
        'org_name': _orgNameController.text.trim(),
        'event_name': _eventNameController.text.trim(),
        'description': _descController.text.trim(),
        'location': _locationController.text.trim(),
        'contact': _contactController.text.trim(),
        'datetime': _selectedDateTime?.toIso8601String(),
        'image_url': null,
      };

      // لو فيه صورة، نرفعها ونأخذ الرابط
      if (_eventImage != null) {
        final url = await _uploadImageToSupabase(_eventImage!);
        if (url != null) eventInfo['image_url'] = url;
      }

      final inserted = await addCompanyEvent(eventInfo);

      if (inserted && mounted) {
        showCustomSnackbar(context, 'تم حفظ معلومات الفعالية بنجاح');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EventCapacityScreen(eventInfo: eventInfo, isPublicEvent: true),
          ),
        );
      } else {
        if (mounted)
          showCustomSnackbar(context, 'فشل حفظ البيانات، حاول لاحقاً');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            blendMode: BlendMode.srcIn,
            child: const Text(
              'إنشاء فعالية للمنظمات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'Rubik',
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event image picker
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            _eventImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      _eventImage!,
                                      width: double.infinity,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.18,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                  ),
                            if (_isImageLoading)
                              Container(
                                width: double.infinity,
                                height: 250,
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isImageLoading ? null : _pickImage,
                            icon: const Icon(Icons.upload, size: 20),
                            label: Text(
                              _eventImage == null
                                  ? 'إضافة صورة للفعالية'
                                  : 'تغيير الصورة',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _SectionTitle('معلومات الفعالية'),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _ModernTextField(
                          controller: _orgNameController,
                          label: 'اسم المنظمة',
                          hint: 'مثال: شركة التقنية الحديثة',
                          icon: Icons.business,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ModernTextField(
                          controller: _eventNameController,
                          label: 'اسم الفعالية',
                          hint: 'مثال: ملتقى الشركات',
                          icon: Icons.event,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _ModernTextField(
                    controller: _descController,
                    label: 'وصف الفعالية',
                    hint: 'اكتب وصفًا موجزًا للفعالية',
                    icon: Icons.description,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle('التاريخ والوقت', size: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _ModernChipButton(
                          label: 'التاريخ',
                          value: _selectedDateTime != null
                              ? DateFormat(
                                  'yyyy/MM/dd',
                                  'ar',
                                ).format(_selectedDateTime!)
                              : null,
                          icon: Icons.calendar_month_rounded,
                          onTap: _pickDateTime,
                          error: null,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _ModernChipButton(
                          label: 'الوقت',
                          value: _selectedDateTime != null
                              ? DateFormat(
                                  'HH:mm',
                                  'ar',
                                ).format(_selectedDateTime!)
                              : null,
                          icon: Icons.access_time_rounded,
                          onTap: _pickTime,
                          error: null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _ModernTextField(
                    controller: _locationController,
                    label: 'الموقع',
                    hint: 'مثال: قاعة المؤتمرات - الرياض',
                    icon: Icons.location_on_rounded,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 20),
                  _ModernTextField(
                    controller: _contactController,
                    label: 'البريد الإلكتروني للتواصل',
                    hint: 'example@email.com',
                    icon: Icons.email,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
                      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
                      if (!emailRegex.hasMatch(v))
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomButton(label: 'التالي', onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// النص، الزر والـ Chip (نفس ما أرسلته أنت، فقط منسقة لتعمل مع الكود الجديد)
class _ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  const _ModernTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 6),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: _GradientOutlinePainter(
                  borderRadius: 18,
                  strokeWidth: 2,
                  gradient: AppColors.primaryGradient,
                ),
                child: const SizedBox.expand(),
              ),
              TextFormField(
                controller: controller,
                validator: validator,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13.5,
                  ),
                  prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
                style: const TextStyle(color: Colors.grey, fontSize: 13.5),
                textDirection: ui.TextDirection.rtl,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GradientOutlinePainter extends CustomPainter {
  final double borderRadius;
  final double strokeWidth;
  final Gradient gradient;
  _GradientOutlinePainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.gradient,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModernChipButton extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;
  final String? error;
  const _ModernChipButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.value,
    this.error,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: _GradientOutlinePainter(
                  borderRadius: 18,
                  strokeWidth: 2,
                  gradient: AppColors.primaryGradient,
                ),
                child: const SizedBox.expand(),
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          value ?? label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                            fontWeight: value != null
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4),
            child: Text(
              error!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final double size;
  const _SectionTitle(this.title, {this.size = 17, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: size,
          color: AppColors.text,
        ),
      ),
    );
  }
}
