class OrganizationModel {
  final int? id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrganizationModel({
    this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory OrganizationModel.fromMap(Map<String, dynamic> map) =>
      OrganizationModel(
        id: map['id'] as int?,
        name: map['name'] as String,
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
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
