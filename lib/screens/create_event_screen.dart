import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // تم التأكد من إضافة التوطين
import 'package:qr_ksa/core/constants.dart';
import 'package:qr_ksa/widgets/custom_button.dart';
import 'package:qr_ksa/screens/select_attendees_screen.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'dart:io';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  PlatformFile? _pickedFile;
  bool _isSubmitting = false;
  bool _submitted = false; // للتحكم في عرض رسائل الخطأ بعد محاولة الإدخال

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    FocusScope.of(context).unfocus(); // إغلاق لوحة المفاتيح إن وجدت
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // انتظار اختياري قصير
    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        locale: const Locale('ar'), // ضمان عرض التقويم بالعربية
        textDirection: ui.TextDirection.rtl, // عرض من اليمين لليسار
        builder: (context, child) {
          return Directionality(
            // تأكيد اتجاه النص إلى اليمين
            textDirection: ui.TextDirection.rtl,
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.surface,
                  onSurface: AppColors.text,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
              child: child!,
            ),
          );
        },
      );
      if (picked != null) {
        setState(() => _selectedDate = picked);
      }
    } catch (e) {
      debugPrint("DatePicker Error: $e");
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 100));
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        // نجعل اتجاه عنصر الوقت أيضًا من اليمين لليسار
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Theme(data: Theme.of(context), child: child!),
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _pickedFile = result.files.first);
    }
  }

  void _removeFile() => setState(() => _pickedFile = null);

  String? get dateText {
    if (_selectedDate == null) return null;
    // تنسيق التاريخ ليظهر باللغة العربية (مثال: الجمعة، 1 يناير 2025)
    return DateFormat('EEEE، d MMMM yyyy', 'ar_SA').format(_selectedDate!);
  }

  String? get timeText {
    if (_selectedTime == null) return null;
    final hour = _selectedTime!.hourOfPeriod == 0
        ? 12
        : _selectedTime!.hourOfPeriod;
    final minute = _selectedTime!.minute.toString().padLeft(2, '0');
    final period = _selectedTime!.period == DayPeriod.am ? 'صباحًا' : 'مساءً';
    return '$hour:$minute $period';
  }

  void _submitForm() async {
    setState(() => _submitted = true);
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() == true &&
        _selectedDate != null &&
        _selectedTime != null) {
      setState(() => _isSubmitting = true);
      try {
        final uri = Uri.parse(
          'https://vfajkxdyzwdnurfnaqdy.supabase.co',
        ); // <-- Replace with your real endpoint
        final request = http.MultipartRequest('POST', uri);
        request.fields['name'] = _nameController.text.trim();
        request.fields['location'] = _locationController.text.trim();
        final dateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        request.fields['date_time'] = dateTime.toIso8601String();
        // Add image if picked
        if (_pickedFile != null && _pickedFile!.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              _pickedFile!.path!,
              filename: _pickedFile!.name,
            ),
          );
        }
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        if (!mounted) return;
        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم الحفظ بنجاح!')));
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SelectAttendeesScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('لم يتم الحفظ! (${response.statusCode})')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('لم يتم الحفظ! ($e)')));
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      // جعل اتجاه الشاشة بالكامل من اليمين لليسار
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 85,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Text(
                        'إنشاء فعالية جديدة',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          shadows: [
                            const Shadow(color: Colors.black26, blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle('معلومات الفعالية'),
                      _ModernTextField(
                        controller: _nameController,
                        label: 'اسم الفعالية',
                        hint: 'مثال: مؤتمر البرمجة',
                        icon: Icons.event_available_rounded,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'يرجى إدخال اسم الفعالية';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _SectionTitle('التاريخ والوقت', size: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _ModernChipButton(
                              label: 'التاريخ',
                              value: dateText,
                              icon: Icons.calendar_month_rounded,
                              onTap: () => _pickDate(context),
                              error: (_submitted && _selectedDate == null)
                                  ? 'اختر التاريخ'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ModernChipButton(
                              label: 'الوقت',
                              value: timeText,
                              icon: Icons.access_time_rounded,
                              onTap: () => _pickTime(context),
                              error: (_submitted && _selectedTime == null)
                                  ? 'اختر الوقت'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _ModernTextField(
                        controller: _locationController,
                        label: 'الموقع',
                        hint: 'مثال: قاعة الملك فهد',
                        icon: Icons.location_on_rounded,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'يرجى إدخال الموقع';
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),
                      _SectionTitle('ملف مرفق (اختياري)', size: 15),
                      _ModernFilePicker(
                        file: _pickedFile,
                        onPick: _pickFile,
                        onRemove: _removeFile,
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        label: _isSubmitting ? 'جارٍ المعالجة...' : 'التالي',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: _isSubmitting ? () {} : _submitForm,
                      ),
                    ],
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

// بقية الويجتات المساعدة دون تغيير (SectionTitle, ModernTextField, ModernChipButton, ModernFilePicker)...

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
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.text),
      textDirection: ui.TextDirection.rtl,
    );
  }
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: error != null
                    ? Colors.redAccent
                    : AppColors.primary.withOpacity(0.2),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value ?? label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: value != null ? AppColors.text : Colors.grey,
                      fontWeight: value != null
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
              ],
            ),
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

// تعريف الويجت المفقود ModernFilePicker
class _ModernFilePicker extends StatelessWidget {
  final PlatformFile? file;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const _ModernFilePicker({
    required this.file,
    required this.onPick,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (file != null)
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.insert_drive_file_rounded, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    file!.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: onRemove,
                  tooltip: 'إزالة الملف',
                ),
              ],
            ),
          )
        else
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
            icon: const Icon(Icons.attach_file_rounded),
            label: const Text('إرفاق ملف'),
            onPressed: onPick,
          ),
      ],
    );
  }
}
