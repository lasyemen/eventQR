class EventCapacityModel {
  final int id;
  final int eventId;
  final int reserved;
  final int checkedIn;
  final DateTime updatedAt;

  EventCapacityModel({
    required this.id,
    required this.eventId,
    required this.reserved,
    required this.checkedIn,
    required this.updatedAt,
  });

  factory EventCapacityModel.fromJson(Map<String, dynamic> json) =>
      EventCapacityModel(
        id: json['id'],
        eventId: json['event_id'],
        reserved: json['reserved'],
        checkedIn: json['checked_in'],
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'reserved': reserved,
    'checked_in': checkedIn,
    'updated_at': updatedAt.toIso8601String(),
  };
}
