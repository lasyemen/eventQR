class OrganizationModel {
  final int? id;
  final String name;
  final String? contactEmail;
  final String? contactPhone;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrganizationModel({
    this.id,
    required this.name,
    this.contactEmail,
    this.contactPhone,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory OrganizationModel.fromMap(Map<String, dynamic> map) =>
      OrganizationModel(
        id: map['id'] as int?,
        name: map['name'] as String,
        contactEmail: map['contact_email'] as String?,
        contactPhone: map['contact_phone'] as String?,
        createdBy: map['created_by'] as int?,
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
    'contact_email': contactEmail,
    'contact_phone': contactPhone,
    'created_by': createdBy,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
