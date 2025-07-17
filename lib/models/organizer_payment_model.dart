class OrganizerPaymentModel {
  final int id;
  final int organizerId;
  final int eventId;
  final double amount;
  final String status;
  final DateTime? paidAt;

  OrganizerPaymentModel({
    required this.id,
    required this.organizerId,
    required this.eventId,
    required this.amount,
    required this.status,
    this.paidAt,
  });

  factory OrganizerPaymentModel.fromJson(Map<String, dynamic> json) =>
      OrganizerPaymentModel(
        id: json['id'],
        organizerId: json['organizer_id'],
        eventId: json['event_id'],
        amount: (json['amount'] as num).toDouble(),
        status: json['status'],
        paidAt: json['paid_at'] != null
            ? DateTime.parse(json['paid_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'organizer_id': organizerId,
    'event_id': eventId,
    'amount': amount,
    'status': status,
    'paid_at': paidAt?.toIso8601String(),
  };
}
