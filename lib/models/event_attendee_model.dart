class EventAttendeeModel {
  final int id;
  final int eventId;
  final int attendeeId;
  final String invitationStatus;
  final int? qrCodeId;
  final DateTime? confirmedAt;

  EventAttendeeModel({
    required this.id,
    required this.eventId,
    required this.attendeeId,
    required this.invitationStatus,
    this.qrCodeId,
    this.confirmedAt,
  });

  factory EventAttendeeModel.fromJson(Map<String, dynamic> json) =>
      EventAttendeeModel(
        id: json['id'],
        eventId: json['event_id'],
        attendeeId: json['attendee_id'],
        invitationStatus: json['invitation_status'],
        qrCodeId: json['qr_code_id'],
        confirmedAt: json['confirmed_at'] != null
            ? DateTime.parse(json['confirmed_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'attendee_id': attendeeId,
    'invitation_status': invitationStatus,
    'qr_code_id': qrCodeId,
    'confirmed_at': confirmedAt?.toIso8601String(),
  };
}
