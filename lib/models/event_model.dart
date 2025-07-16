class EventModel {
  final int? id;
  final int? organizationId;
  final String name;
  final String? description;
  final String? location;
  final String? imageUrl;
  final DateTime dateTime;
  final int? capacity;
  final int? ticketsTotal;
  final bool isPublic;
  final String status;
  final int? planId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EventModel({
    this.id,
    this.organizationId,
    required this.name,
    this.description,
    this.location,
    this.imageUrl,
    required this.dateTime,
    this.capacity,
    this.ticketsTotal,
    this.isPublic = true,
    this.status = 'draft',
    this.planId,
    this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) => EventModel(
    id: map['id'] as int?,
    organizationId: map['organization_id'] as int?,
    name: map['name'] as String,
    description: map['description'] as String?,
    location: map['location'] as String?,
    imageUrl: map['image_url'] as String?,
    dateTime: DateTime.parse(map['date_time']),
    capacity: map['capacity'] as int?,
    ticketsTotal: map['tickets_total'] as int?,
    isPublic: map['is_public'] ?? true,
    status: map['status'] as String? ?? 'draft',
    planId: map['plan_id'] as int?,
    createdAt: map['created_at'] != null
        ? DateTime.parse(map['created_at'])
        : null,
    updatedAt: map['updated_at'] != null
        ? DateTime.parse(map['updated_at'])
        : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'organization_id': organizationId,
    'name': name,
    'description': description,
    'location': location,
    'image_url': imageUrl,
    'date_time': dateTime.toIso8601String(),
    'capacity': capacity,
    'tickets_total': ticketsTotal,
    'is_public': isPublic,
    'status': status,
    'plan_id': planId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
