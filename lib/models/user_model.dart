class UserModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String passwordHash;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.passwordHash,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    passwordHash: json['password_hash'],
    role: json['role'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'password_hash': passwordHash,
    'role': role,
    'created_at': createdAt.toIso8601String(),
  };
}
