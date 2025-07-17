class ScanModel {
  final int id;
  final int eventId;
  final int attendeeId;
  final int qrCodeId;
  final int scannedBy;
  final DateTime scannedAt;
  final String status;

  ScanModel({
    required this.id,
    required this.eventId,
    required this.attendeeId,
    required this.qrCodeId,
    required this.scannedBy,
    required this.scannedAt,
    required this.status,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
    id: json['id'],
    eventId: json['event_id'],
    attendeeId: json['attendee_id'],
    qrCodeId: json['qr_code_id'],
    scannedBy: json['scanned_by'],
    scannedAt: DateTime.parse(json['scanned_at']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'attendee_id': attendeeId,
    'qr_code_id': qrCodeId,
    'scanned_by': scannedBy,
    'scanned_at': scannedAt.toIso8601String(),
    'status': status,
  };
}
