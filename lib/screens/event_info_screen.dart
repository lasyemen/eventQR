import 'package:flutter/material.dart';
import 'select_attendees_screen.dart';

class EventInfoScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  EventInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('معلومات الفعالية')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم الفعالية'),
              ),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'نوع الفعالية (زواج، ملكة...)',
                ),
              ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'تاريخ الفعالية'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    dateController.text =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  }
                },
                readOnly: true,
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () {
                  // Validation...
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SelectAttendeesScreen()),
                  );
                },
                child: const Text('التالي: اختيار الحضور'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
