import 'dart:async';

import 'package:admin/network/auth_iterceptor.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/equipments/data/equipment_service.dart';
// Kelajakda boshqa service-larni ham shu yerga import qilasiz

final apiClientProvider = Provider<ChopperClient>((ref) {
  return ChopperClient(
    // .NET backend manzili (Emulator uchun 10.0.2.2 ishlatiladi)
    baseUrl: Uri.parse('http://10.0.2.2:5000'),

    // Barcha service-larni bitta joyda ro'yxatdan o'tkazamiz
    services: [
      EquipmentService.create(),
      // AuthService.create(),
      // BookingService.create(),
    ],

    // JSON-ni avtomatik o'girish uchun markaziy konverter
    converter: const JsonConverter(),

    // BARCHA service-lar uchun bir xil interceptorlar
    interceptors: [
      HttpLoggingInterceptor(),
      AuthInterceptor()
    ],
  );
});
