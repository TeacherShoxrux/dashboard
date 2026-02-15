// lib/features/equipment/domain/models/equipment_model.dart
class EquipmentModel {
  final int id;
  final String name;
  final double pricePerDay; // Ijara narxi

  EquipmentModel({
    required this.id,
    required this.name,
    required this.pricePerDay,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'],
      name: json['name'],
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
    );
  }
}