class EventPlanModel {
  final int? id;
  final String name;
  final double price;
  final String? features;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EventPlanModel({
    this.id,
    required this.name,
    required this.price,
    this.features,
    this.createdAt,
    this.updatedAt,
  });

  factory EventPlanModel.fromMap(Map<String, dynamic> map) => EventPlanModel(
    id: map['id'] as int?,
    name: map['name'] as String,
    price: map['price'] is double
        ? map['price'] as double
        : double.parse(map['price'].toString()),
    features: map['features'] as String?,
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
    'price': price,
    'features': features,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
