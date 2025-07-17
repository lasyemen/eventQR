import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class PaymentSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;
  const PaymentSuccessScreen({Key? key, required this.eventData})
    : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isSaving = true;
  bool _saveSuccess = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _submitEventToSupabase();
  }

  Future<void> _submitEventToSupabase() async {
    final client = Supabase.instance.client;
    final eventData = widget.eventData;
    final orgIdRaw = eventData['organization_id'] ?? 1;
    final int orgId = orgIdRaw is int
        ? orgIdRaw
        : int.tryParse(orgIdRaw.toString()) ?? 1;
    final insertData = {
      'organization_id': orgId,
      'name': eventData['eventName'],
      'description': eventData['desc'],
      'location': eventData['location'],
      'image_url': eventData['imageUrl'],
      'date_time': eventData['dateTime'],
      'capacity': eventData['capacity'],
      'tickets_total': eventData['tickets'],
      'contact': eventData['contact'],
    };
    print('Inserting event:');
    print(insertData);
    try {
      final response = await client
          .from('public_events')
          .insert(insertData)
          .select();
      if (response == null || (response is List && response.isEmpty)) {
        setState(() {
          _isSaving = false;
          _saveSuccess = false;
          _errorMessage = 'فشل حفظ الفعالية: لا يوجد رد من Supabase';
        });
      } else if (response is! List) {
        setState(() {
          _isSaving = false;
          _saveSuccess = false;
          _errorMessage = 'فشل حفظ الفعالية: ${response.toString()}';
        });
      } else {
        setState(() {
          _isSaving = false;
          _saveSuccess = true;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _saveSuccess = false;
        _errorMessage = 'فشل حفظ الفعالية: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateStr = '';
    final eventData = widget.eventData;
    if (eventData['dateTime'] != null &&
        eventData['dateTime'].toString().isNotEmpty) {
      try {
        final dt = DateTime.parse(eventData['dateTime']);
        dateStr = DateFormat('yyyy/MM/dd - HH:mm', 'ar').format(dt);
      } catch (_) {
        dateStr = eventData['dateTime'].toString();
      }
    }
    final location = eventData['location'] ?? '';
    final eventName = eventData['eventName'] ?? '-';
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGradient.colors.first.withOpacity(
                        0.18,
                      ),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _isSaving
                    ? 'جاري حفظ الفعالية...'
                    : _saveSuccess
                    ? 'تم تفعيل الفعالية بنجاح!'
                    : _errorMessage ?? 'حدث خطأ',
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.event,
                          color: Colors.black54,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            eventName,
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.black54,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.black54,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (_isSaving)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveSuccess
                        ? () {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'العودة للرئيسية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
