// lib/features/equipment/domain/models/equipment.dart
class Equipment {
  final int id;
  final String name;
  final double pricePerDay; // Ijara narxi

  Equipment({
    required this.id,
    required this.name,
    required this.pricePerDay,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
    );
  }
}