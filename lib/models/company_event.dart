import 'package:meta/meta.dart';

class CompanyEvent {
  final String? id;
  final String orgName;
  final String eventName;
  final String description;
  final String location;
  final String contact;
  final DateTime dateTime;
  final String? imageUrl;
  final DateTime? createdAt;

  CompanyEvent({
    this.id,
    required this.orgName,
    required this.eventName,
    required this.description,
    required this.location,
    required this.contact,
    required this.dateTime,
    this.imageUrl,
    this.createdAt,
  });

  factory CompanyEvent.fromMap(Map<String, dynamic> map) {
    return CompanyEvent(
      id: map['id'],
      orgName: map['org_name'],
      eventName: map['event_name'],
      description: map['description'] ?? '',
      location: map['location'],
      contact: map['contact'],
      dateTime: DateTime.parse(map['date_time']),
      imageUrl: map['image_url'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'org_name': orgName,
      'event_name': eventName,
      'description': description,
      'location': location,
      'contact': contact,
      'date_time': dateTime.toIso8601String(),
      'image_url': imageUrl,
      // Do not send id or createdAt on insert
    };
  }
}
