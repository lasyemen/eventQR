import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:qr_ksa/core/constants.dart';
import 'package:qr_ksa/widgets/custom_button.dart';
import 'package:qr_ksa/screens/select_attendees_screen.dart' hide AppColors;

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});
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

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _pickedFile = result.files.first);
    }
  }

  void _removeFile() => setState(() => _pickedFile = null);

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      locale: const Locale("ar", "SA"),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ),
        child: Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        ),
      ),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  String? get dateText {
    if (_selectedDate == null) return null;
    final formatter = DateFormat('EEEE، d MMMM yyyy', 'ar_SA');
    return formatter.format(_selectedDate!);
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
    if (_formKey.currentState?.validate() == true &&
        _selectedDate != null &&
        _selectedTime != null) {
      setState(() => _isSubmitting = true);
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // مجرد محاكاة تحميل سريع
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SelectAttendeesScreen()));
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 100,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
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
                              Shadow(color: Colors.black26, blurRadius: 6),
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
                    horizontal: 22,
                    vertical: 25,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _SectionTitle('معلومات الفعالية'),
                        const SizedBox(height: 8),
                        _ModernTextField(
                          controller: _nameController,
                          label: 'اسم الفعالية',
                          hint: 'مثال: مؤتمر البرمجة',
                          icon: Icons.event_available_rounded,
                          validator: (val) => (val == null || val.isEmpty)
                              ? 'يرجى إدخال اسم الفعالية'
                              : null,
                        ),
                        const SizedBox(height: 22),
                        _SectionTitle('التاريخ والوقت', size: 15),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _ModernChipButton(
                                label: 'التاريخ',
                                value: dateText,
                                icon: Icons.calendar_month_rounded,
                                onTap: () => _pickDate(context),
                                error: _selectedDate == null
                                    ? 'اختر التاريخ'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ModernChipButton(
                                label: 'الوقت',
                                value: timeText,
                                icon: Icons.access_time_rounded,
                                onTap: () => _pickTime(context),
                                error: _selectedTime == null
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
                          validator: (val) => (val == null || val.isEmpty)
                              ? 'يرجى إدخال الموقع'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        _SectionTitle('ملف مرفق (اختياري)', size: 15),
                        const SizedBox(height: 7),
                        _ModernFilePicker(
                          file: _pickedFile,
                          onPick: _pickFile,
                          onRemove: _removeFile,
                        ),
                        const SizedBox(height: 34),
                        CustomButton(
                          label: _isSubmitting ? 'جارٍ المعالجة...' : 'التالي',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _isSubmitting
                              ? () {}
                              : () => _submitForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final double size;
  const _SectionTitle(this.text, {this.size = 18});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: 0.5,
      ),
    ),
  );
}

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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(fontSize: 15.7, color: AppColors.text),
          decoration: InputDecoration(
            prefixIcon: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 7),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.2,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 13,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.25),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.6,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.17),
                width: 1.1,
              ),
            ),
          ),
        ),
      ],
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
    required this.value,
    required this.icon,
    required this.onTap,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 155, // ثبات العرض
            height: 58, // ثبات الطول
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
              decoration: BoxDecoration(
                gradient: selected ? AppColors.primaryGradient : null,
                color: selected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: error != null
                      ? AppColors.error
                      : selected
                      ? AppColors.primary
                      : AppColors.inputBorder,
                  width: selected ? 1.8 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7.2),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: selected ? AppColors.primary : AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value ?? 'اختر $label',
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontSize: 15.2,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: selected
                        ? Colors.white
                        : AppColors.primary.withOpacity(0.45),
                  ),
                ],
              ),
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 7, right: 7),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    error!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 11.7,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ModernFilePicker extends StatelessWidget {
  final PlatformFile? file;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  const _ModernFilePicker({
    required this.file,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: file == null ? AppColors.inputBorder : AppColors.success,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.attach_file_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                file == null ? 'اضغط لرفع ملف (صورة أو PDF)' : file!.name,
                style: TextStyle(
                  fontSize: 15.5,
                  color: file == null
                      ? AppColors.textSecondary
                      : AppColors.text,
                  fontWeight: file == null
                      ? FontWeight.normal
                      : FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (file != null)
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: 22,
                ),
                onPressed: onRemove,
                tooltip: 'حذف الملف',
              ),
          ],
        ),
      ),
    );
  }
}
