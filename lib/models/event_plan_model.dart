class EventPlanModel {
  final int? id;
  final String name;
  final double price;
  final String? features;

  EventPlanModel({
    this.id,
    required this.name,
    required this.price,
    this.features,
  });

  factory EventPlanModel.fromMap(Map<String, dynamic> map) => EventPlanModel(
    id: map['id'] as int?,
    name: map['name'] as String,
    price: (map['price'] as num).toDouble(),
    features: map['features'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'features': features,
  };
}
