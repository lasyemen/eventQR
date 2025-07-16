class TicketModel {
  final int? id;
  final int? eventId;
  final String type;
  final double price;
  final String status;
  final String? qrCode;
  final int? purchasedBy;
  final DateTime? purchasedAt;

  TicketModel({
    this.id,
    this.eventId,
    this.type = 'regular',
    required this.price,
    this.status = 'available',
    this.qrCode,
    this.purchasedBy,
    this.purchasedAt,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map) => TicketModel(
    id: map['id'] as int?,
    eventId: map['event_id'] as int?,
    type: map['type'] as String? ?? 'regular',
    price: (map['price'] as num).toDouble(),
    status: map['status'] as String? ?? 'available',
    qrCode: map['qr_code'] as String?,
    purchasedBy: map['purchased_by'] as int?,
    purchasedAt: map['purchased_at'] != null
        ? DateTime.parse(map['purchased_at'])
        : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'event_id': eventId,
    'type': type,
    'price': price,
    'status': status,
    'qr_code': qrCode,
    'purchased_by': purchasedBy,
    'purchased_at': purchasedAt?.toIso8601String(),
  };
}
