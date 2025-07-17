class EventModel {
  final int id;
  final int organizerId;
  final String name;
  final String type;
  final String? description;
  final String location;
  final DateTime eventDate;
  final String? eventTime;
  final int capacity;
  final String status;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.organizerId,
    required this.name,
    required this.type,
    this.description,
    required this.location,
    required this.eventDate,
    this.eventTime,
    required this.capacity,
    required this.status,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json['id'],
    organizerId: json['organizer_id'],
    name: json['name'],
    type: json['type'],
    description: json['description'],
    location: json['location'],
    eventDate: DateTime.parse(json['event_date']),
    eventTime: json['event_time'],
    capacity: json['capacity'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'organizer_id': organizerId,
    'name': name,
    'type': type,
    'description': description,
    'location': location,
    'event_date': eventDate.toIso8601String(),
    'event_time': eventTime,
    'capacity': capacity,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}
