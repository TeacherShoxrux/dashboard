class CustomerCreateModel {
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String passportSeries;
  String passportNumber;
  String jShShir;
  bool isWoman;
  bool isOriginalDocumentLeft;
  String? address;
  String? note;
  String? userPhotoUrl;
  List<String> documentScans;
  List<PhoneRequestModel> phones;
  CustomerCreateModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.passportSeries,
    required this.passportNumber,
    required this.jShShir,
    required this.isWoman,
    required this.isOriginalDocumentLeft,
    this.address,
    this.note,
    this.userPhotoUrl,
    required this.documentScans,
    required this.phones,
  });
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName.toUpperCase(),
      "lastName": lastName.toLowerCase(),
      "dateOfBirth": dateOfBirth.toIso8601String(), // ISO formatda yuborish
      "passportSeries": passportSeries.toUpperCase(),
      "passportNumber": passportNumber.toUpperCase(),
      "jShShIR": jShShir,
      "isWoman": isWoman,
      "isOriginalDocumentLeft": isOriginalDocumentLeft,
      "address": address,
      "note": note,
      "userPhotoUrl": userPhotoUrl,
      "documentScans": documentScans, // String list [ "url1", "url2" ]
      "phones": phones.map((x) => x.toJson()).toList(), // Listni xaritaga aylantirish
    };
  }
}

class PhoneRequestModel {
  String name;
  String phoneNumber;

  PhoneRequestModel({
    required this.name,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name.toUpperCase(),
      "phoneNumber": phoneNumber,
    };
  }
}