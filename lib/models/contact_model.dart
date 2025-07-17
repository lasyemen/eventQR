class ContactModel {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String email;
  final DateTime addedAt;

  ContactModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.addedAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    id: json['id'],
    userId: json['user_id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    addedAt: DateTime.parse(json['added_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'phone': phone,
    'email': email,
    'added_at': addedAt.toIso8601String(),
  };
}
