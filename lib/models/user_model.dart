class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String passwordHash;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.passwordHash,
    this.role = 'attendee',
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] as int?,
    name: map['name'] as String,
    email: map['email'] as String,
    phone: map['phone'] as String?,
    passwordHash: map['password_hash'] as String,
    role: map['role'] as String? ?? 'attendee',
    createdAt: map['created_at'] != null
        ? DateTime.parse(map['created_at'])
        : null,
    updatedAt: map['updated_at'] != null
        ? DateTime.parse(map['updated_at'])
        : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'password_hash': passwordHash,
    'role': role,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
