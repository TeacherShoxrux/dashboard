class CustomerModel {
  final int id;
  final DateTime? createdAt;
  final double currentDebt;
  final String? photoUrl;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String passportSeries;
  final String passportNumber;
  final String jShShir;
  final bool? isWoman;
  bool isOriginalDocumentLeft;
  final String? address;
  final String? note;
  final String? userPhoto;
  final List<dynamic>? documentScans;
  final List<dynamic> phones;

  CustomerModel({
    required this.id,
    this.createdAt,
    required this.currentDebt,
    this.photoUrl,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    required this.passportSeries,
    required this.passportNumber,
    required this.jShShir,
    this.isWoman,
    required this.isOriginalDocumentLeft,
    this.address,
    this.note,
    this.userPhoto,
    this.documentScans,
    required this.phones,
  });

  // JSON dan obyekt yaratish (Factory method)
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      currentDebt: (json['currentDebt'] ?? 0).toDouble(),
      photoUrl: json['photoUrl'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
      passportSeries: json['passportSeries'] ?? '',
      passportNumber: json['passportNumber'] ?? '',
      jShShir: json['jShShIR'] ?? '',
      isWoman: json['isWoman'],
      isOriginalDocumentLeft: json['isOriginalDocumentLeft'] ?? false,
      address: json['address'],
      note: json['note'],
      userPhoto: json['userPhoto'],
      documentScans: json['documentScans'],
      phones: json['phones'] ?? [],
    );
  }

  // Obyektni JSON formatiga o'tkazish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'currentDebt': currentDebt,
      'photoUrl': photoUrl,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'passportSeries': passportSeries,
      'passportNumber': passportNumber,
      'jShShIR': jShShir,
      'isWoman': isWoman,
      'isOriginalDocumentLeft': isOriginalDocumentLeft,
      'address': address,
      'note': note,
      'userPhoto': userPhoto,
      'documentScans': documentScans,
      'phones': phones,
    };
  }

  // To'liq ismni olish uchun qulay metod (Helper)
  String get fullName => '$firstName $lastName';
}