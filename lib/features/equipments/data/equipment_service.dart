// lib/features/equipment/data/services/equipment_service.dart
import 'package:chopper/chopper.dart';

// Kod generatori uchun kerak
part 'equipment_service.chopper.dart';

@ChopperApi(baseUrl: '/api/equipment') // .NET Controller manzili
abstract class EquipmentService extends ChopperService {

  // Barcha uskunalarni olish
  @GET()
  Future<Response> getEquipments();

  // ID bo'yicha bitta uskunani olish
  @GET(path: '/{id}')
  Future<Response> getEquipmentDetails(@Path('id') int id);

  // Yangi uskuna qo'shish (Admin uchun)
  @POST()
  Future<Response> addEquipment(@Body() Map<String, dynamic> body);

  static EquipmentService create([ChopperClient? client]) {
    return _$EquipmentService(client);
  }
}