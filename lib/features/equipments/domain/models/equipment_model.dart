class EquipmentModel {
  final int id;
  final String name;
  final String brandName;
  final String categoryName;
  final double pricePerDay;
  final String? imageUrl; // Null bo'lishi mumkinligini hisobga olamiz
  final int availableCount;

  EquipmentModel({
    required this.id,
    required this.name,
    required this.brandName,
    required this.categoryName,
    required this.pricePerDay,
    this.imageUrl,
    required this.availableCount,
  });

  // JSON-dan Dart ob'ektiga o'girish (Factory Constructor)
  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      brandName: json['brandName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'], // null kelsa null bo'lib qoladi
      availableCount: json['availableCount'] ?? 0,
    );
  }
}