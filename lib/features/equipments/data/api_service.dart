// lib/features/equipment/data/services/api_service.dart
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http show MultipartFile;
import 'package:http/http.dart' show MultipartFile;
import '../../../network/model_response.dart';
import '../../../network/response_base.dart';
import '../domain/models/equipment_model.dart';

// Kod generatori uchun kerak
part 'api_service.chopper.dart';

@ChopperApi(baseUrl: '/api') // .NET Controller manzili
abstract class ApiService extends ChopperService {
  @GET(path: '/Equipments')
  Future<Response<dynamic>> getEquipments(
      {@Query('BrandId') int? brandId,
      @Query('CategoryId') int? categoryId,
      @Query('Search') String? search,
      @Query('Page') int? page = 1,
      @Query('PageSize') int? pageSize = 20});

  @GET(path: '/Equipments/brands')
  Future<Response> getBrand();

  @Post(path: '/Files/upload')
  @Multipart()
  Future<Response> uploadFile(@PartFile('file') http.MultipartFile file);

  @POST(path: '/Equipments/brands')
  Future<Response> createBrand(@Query("Name") String name, @Query("Details") String description,[ @Query("ImageUrl") String? imagePath]);

  @GET(path: '/Equipments/categories')
  Future<Response> getCategories();

  @GET(path: '/Equipments/brands/{id}/categories')
  Future<Response> getByBrandIdCategories(@Path("id") int id);

  @POST(path: '/Equipments/categories')
  Future<Response> createCategories();

  @POST()
  Future<Response> addEquipment(@Body() Map<String, dynamic> body);

  static ApiService create([ChopperClient? client]) {
    return _$ApiService(client);
  }
}
