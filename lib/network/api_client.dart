import 'dart:async';

import 'package:admin/network/auth_iterceptor.dart';
import 'package:admin/network/result_converter.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/equipments/data/equipment_service.dart';
import 'api_constants.dart';
// Kelajakda boshqa service-larni ham shu yerga import qilasiz

final apiClientProvider = Provider<ChopperClient>((ref) {
  return ChopperClient(
    baseUrl: Uri.parse(ApiConstants.baseUrl),
    services: [
      EquipmentService.create(),
      // AuthService.create(),
      // BookingService.create(),
    ],

    // JSON-ni avtomatik o'girish uchun markaziy konverter
    converter: ResultConverter(),

    // BARCHA service-lar uchun bir xil interceptorlar
    interceptors: [
      HttpLoggingInterceptor(),
      // AuthInterceptor()
    ],
  );
});
