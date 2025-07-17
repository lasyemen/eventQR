class EventSecurityModel {
  final int id;
  final int eventId;
  final int userId;
  final String role;
  final DateTime assignedAt;

  EventSecurityModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.role,
    required this.assignedAt,
  });

  factory EventSecurityModel.fromJson(Map<String, dynamic> json) =>
      EventSecurityModel(
        id: json['id'],
        eventId: json['event_id'],
        userId: json['user_id'],
        role: json['role'],
        assignedAt: DateTime.parse(json['assigned_at']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'user_id': userId,
    'role': role,
    'assigned_at': assignedAt.toIso8601String(),
  };
}
