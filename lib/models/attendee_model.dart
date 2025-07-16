class AttendeeModel {
  final int? id;
  final int? eventId;
  final int? userId;
  final int? ticketId;
  final String status;
  final DateTime? checkedInAt;

  AttendeeModel({
    this.id,
    this.eventId,
    this.userId,
    this.ticketId,
    this.status = 'invited',
    this.checkedInAt,
  });

  factory AttendeeModel.fromMap(Map<String, dynamic> map) => AttendeeModel(
    id: map['id'] as int?,
    eventId: map['event_id'] as int?,
    userId: map['user_id'] as int?,
    ticketId: map['ticket_id'] as int?,
    status: map['status'] as String? ?? 'invited',
    checkedInAt: map['checked_in_at'] != null
        ? DateTime.parse(map['checked_in_at'])
        : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'event_id': eventId,
    'user_id': userId,
    'ticket_id': ticketId,
    'status': status,
    'checked_in_at': checkedInAt?.toIso8601String(),
  };
}
