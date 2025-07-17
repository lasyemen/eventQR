class AttendeeModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final bool isConfirmed;
  final DateTime createdAt;

  AttendeeModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.isConfirmed,
    required this.createdAt,
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> json) => AttendeeModel(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    isConfirmed: json['is_confirmed'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'is_confirmed': isConfirmed,
    'created_at': createdAt.toIso8601String(),
  };
}
