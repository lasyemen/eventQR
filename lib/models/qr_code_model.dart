class QRCodeModel {
  final int id;
  final int eventId;
  final int attendeeId;
  final String code;
  final DateTime generatedAt;
  final bool isActive;

  QRCodeModel({
    required this.id,
    required this.eventId,
    required this.attendeeId,
    required this.code,
    required this.generatedAt,
    required this.isActive,
  });

  factory QRCodeModel.fromJson(Map<String, dynamic> json) => QRCodeModel(
    id: json['id'],
    eventId: json['event_id'],
    attendeeId: json['attendee_id'],
    code: json['code'],
    generatedAt: DateTime.parse(json['generated_at']),
    isActive: json['is_active'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'attendee_id': attendeeId,
    'code': code,
    'generated_at': generatedAt.toIso8601String(),
    'is_active': isActive,
  };
}
