class SettingModel {
  final int id;
  final int userId;
  final String settingKey;
  final String settingValue;
  final DateTime updatedAt;

  SettingModel({
    required this.id,
    required this.userId,
    required this.settingKey,
    required this.settingValue,
    required this.updatedAt,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
    id: json['id'],
    userId: json['user_id'],
    settingKey: json['setting_key'],
    settingValue: json['setting_value'],
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'setting_key': settingKey,
    'setting_value': settingValue,
    'updated_at': updatedAt.toIso8601String(),
  };
}
