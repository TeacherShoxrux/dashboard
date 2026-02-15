// lib/features/equipment/data/services/equipment_service.dart
import 'package:chopper/chopper.dart';
import '../../../network/model_response.dart';
import '../../../network/response_base.dart';
import '../domain/models/equipment_model.dart';

// Kod generatori uchun kerak
part 'equipment_service.chopper.dart';

@ChopperApi(baseUrl: '/api/Equipments') // .NET Controller manzili
abstract class EquipmentService extends ChopperService {
  @GET()
  Future<Response<dynamic>> getEquipments(
      {@Query('BrandId') int? brandId,
      @Query('CategoryId') int? categoryId,
      @Query('Search') String? search,
      @Query('Page') int? page = 1,
      @Query('PageSize') int? pageSize = 20});

  @GET(path: '/brands')
  Future<Response> getBrand();

  @POST(path: '/brands')
  Future<Response> createBrand();

  @GET(path: '/categories')
  Future<Response> getCategories();

  @GET(path: '/brands/{id}/categories')
  Future<Response> getByBrandIdCategories(int id);

  @POST(path: '/categories')
  Future<Response> createCategories();

  @POST()
  Future<Response> addEquipment(@Body() Map<String, dynamic> body);

  static EquipmentService create([ChopperClient? client]) {
    return _$EquipmentService(client);
  }
}
