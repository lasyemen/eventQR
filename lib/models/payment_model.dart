class PaymentModel {
  final int? id;
  final int? userId;
  final int? eventId;
  final int? ticketId;
  final double amount;
  final String? method;
  final String status;
  final String? transactionId;
  final DateTime? createdAt;

  PaymentModel({
    this.id,
    this.userId,
    this.eventId,
    this.ticketId,
    required this.amount,
    this.method,
    this.status = 'pending',
    this.transactionId,
    this.createdAt,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) => PaymentModel(
    id: map['id'] as int?,
    userId: map['user_id'] as int?,
    eventId: map['event_id'] as int?,
    ticketId: map['ticket_id'] as int?,
    amount: (map['amount'] as num).toDouble(),
    method: map['method'] as String?,
    status: map['status'] as String? ?? 'pending',
    transactionId: map['transaction_id'] as String?,
    createdAt: map['created_at'] != null
        ? DateTime.parse(map['created_at'])
        : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'event_id': eventId,
    'ticket_id': ticketId,
    'amount': amount,
    'method': method,
    'status': status,
    'transaction_id': transactionId,
    'created_at': createdAt?.toIso8601String(),
  };
}
