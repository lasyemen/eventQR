class EventReviewModel {
  final int id;
  final int eventId;
  final int attendeeId;
  final int rating;
  final String? comment;
  final DateTime reviewedAt;

  EventReviewModel({
    required this.id,
    required this.eventId,
    required this.attendeeId,
    required this.rating,
    this.comment,
    required this.reviewedAt,
  });

  factory EventReviewModel.fromJson(Map<String, dynamic> json) =>
      EventReviewModel(
        id: json['id'],
        eventId: json['event_id'],
        attendeeId: json['attendee_id'],
        rating: json['rating'],
        comment: json['comment'],
        reviewedAt: DateTime.parse(json['reviewed_at']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'attendee_id': attendeeId,
    'rating': rating,
    'comment': comment,
    'reviewed_at': reviewedAt.toIso8601String(),
  };
}
