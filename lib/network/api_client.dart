import 'dart:async';

import 'package:admin/network/auth_iterceptor.dart';
import 'package:admin/network/result_converter.dart';
import 'package:chopper/chopper.dart';
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';
import '../features/equipments/data/api_service.dart';
import 'api_constants.dart';
// // Kelajakda boshqa service-larni ham shu yerga import qilasiz
// final apiClientProvider = Provider<ChopperClient>((ref) {
//
//   return ChopperClient(
//     baseUrl: Uri.parse(ApiConstants.baseUrl),
//     services: [
//       ApiService.create(),
//     ],
//     converter: ResultConverter(),
//     interceptors: [
//       // HttpLoggingInterceptor(),
//       AuthInterceptor(),
//       PrettyChopperLogger()
//       // HttpLoggingInterceptor(level: Level.body,logger: alice.addLog(log))
//
//     ],
//   );
// });
