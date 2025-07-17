class PaymentModel {
  final int id;
  final int eventId;
  final int payerId;
  final double amount;
  final String paymentMethod;
  final String status;
  final DateTime? paymentTime;

  PaymentModel({
    required this.id,
    required this.eventId,
    required this.payerId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.paymentTime,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    id: json['id'],
    eventId: json['event_id'],
    payerId: json['payer_id'],
    amount: (json['amount'] as num).toDouble(),
    paymentMethod: json['payment_method'],
    status: json['status'],
    paymentTime: json['payment_time'] != null
        ? DateTime.parse(json['payment_time'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'payer_id': payerId,
    'amount': amount,
    'payment_method': paymentMethod,
    'status': status,
    'payment_time': paymentTime?.toIso8601String(),
  };
}
