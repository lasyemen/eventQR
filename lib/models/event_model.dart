class PublicEventModel {
  final int? id;
  final int organizationId;
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
  final String? contact;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PublicEventModel({
    this.id,
    required this.organizationId,
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
    this.contact,
    this.createdAt,
    this.updatedAt,
  });

  factory PublicEventModel.fromMap(Map<String, dynamic> map) =>
      PublicEventModel(
        id: map['id'] as int?,
        organizationId: map['organization_id'] is int
            ? map['organization_id'] as int
            : int.parse(map['organization_id'].toString()),
        name: map['name'] as String,
        description: map['description'] as String?,
        location: map['location'] as String?,
        imageUrl: map['image_url'] as String?,
        dateTime: DateTime.parse(map['date_time']),
        capacity: map['capacity'] as int?,
        ticketsTotal: map['tickets_total'] as int?,
        isPublic: map['is_public'] == null
            ? true
            : map['is_public'] == true || map['is_public'] == 1,
        status: map['status'] as String? ?? 'draft',
        planId: map['plan_id'] as int?,
        contact: map['contact'] as String?,
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
    'contact': contact,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class PersonalEventModel {
  final int? id;
  final int userId;
  final String name;
  final String? description;
  final String? location;
  final String? imageUrl;
  final DateTime dateTime;
  final int? capacity;
  final int? ticketsTotal;
  final bool isPublic;
  final String status;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PersonalEventModel({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    this.location,
    this.imageUrl,
    required this.dateTime,
    this.capacity,
    this.ticketsTotal,
    this.isPublic = false,
    this.status = 'draft',
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory PersonalEventModel.fromMap(Map<String, dynamic> map) =>
      PersonalEventModel(
        id: map['id'] as int?,
        userId: map['user_id'] is int
            ? map['user_id'] as int
            : int.parse(map['user_id'].toString()),
        name: map['name'] as String,
        description: map['description'] as String?,
        location: map['location'] as String?,
        imageUrl: map['image_url'] as String?,
        dateTime: DateTime.parse(map['date_time']),
        capacity: map['capacity'] as int?,
        ticketsTotal: map['tickets_total'] as int?,
        isPublic: map['is_public'] == null
            ? false
            : map['is_public'] == true || map['is_public'] == 1,
        status: map['status'] as String? ?? 'draft',
        type: map['type'] as String?,
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'])
            : null,
        updatedAt: map['updated_at'] != null
            ? DateTime.parse(map['updated_at'])
            : null,
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'description': description,
    'location': location,
    'image_url': imageUrl,
    'date_time': dateTime.toIso8601String(),
    'capacity': capacity,
    'tickets_total': ticketsTotal,
    'is_public': isPublic,
    'status': status,
    'type': type,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
