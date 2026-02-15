import 'dart:async';

import 'package:admin/network/auth_iterceptor.dart';
import 'package:admin/network/result_converter.dart';
import 'package:alice/alice.dart';
import 'package:alice/core/alice_logger.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';
import '../features/equipments/data/equipment_service.dart';
import 'api_constants.dart';
// Kelajakda boshqa service-larni ham shu yerga import qilasiz
final alice = Alice();
final apiClientProvider = Provider<ChopperClient>((ref) {

  return ChopperClient(
    baseUrl: Uri.parse(ApiConstants.baseUrl),
    services: [

      EquipmentService.create(),
      // AuthService.create(),
      // BookingService.create(),
    ],
    converter: ResultConverter(),
    interceptors: [
      // HttpLoggingInterceptor(),
      AuthInterceptor(),
      PrettyChopperLogger()
      // HttpLoggingInterceptor(level: Level.body,logger: alice.addLog(log))

    ],
  );
});
