class InvitationModel {
  final int id;
  final int eventId;
  final int attendeeId;
  final int sentBy;
  final DateTime sentAt;
  final String deliveryMethod;
  final String status;

  InvitationModel({
    required this.id,
    required this.eventId,
    required this.attendeeId,
    required this.sentBy,
    required this.sentAt,
    required this.deliveryMethod,
    required this.status,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) =>
      InvitationModel(
        id: json['id'],
        eventId: json['event_id'],
        attendeeId: json['attendee_id'],
        sentBy: json['sent_by'],
        sentAt: DateTime.parse(json['sent_at']),
        deliveryMethod: json['delivery_method'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'attendee_id': attendeeId,
    'sent_by': sentBy,
    'sent_at': sentAt.toIso8601String(),
    'delivery_method': deliveryMethod,
    'status': status,
  };
}
