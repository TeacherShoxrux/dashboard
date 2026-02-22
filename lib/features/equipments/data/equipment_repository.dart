
import 'package:admin/features/equipments/data/api_service.dart';

import '../../../network/base_repository.dart';
import '../../../network/model_response.dart';
import '../../../network/response_base.dart';
import '../domain/models/brand_model.dart';
import '../domain/models/category_model.dart';
import '../domain/models/equipment_model.dart';


class EquipmentRepository with BaseRepository{
  final ApiService _equipmentService;

  EquipmentRepository(this._equipmentService);

  Future<Result<BaseResponse<List<EquipmentModel>>>> getEquipments() async {

    var re=await safeApiCall<List<EquipmentModel>>(
          () => _equipmentService.getEquipments(),
            (json) {
          if (json == null) return <EquipmentModel>[];
          final list = json as List<dynamic>;

          return list.map((item) => EquipmentModel.fromJson(item as Map<String, dynamic>)).toList();
        }

    );

    return re;
  }

  Future<Result<BaseResponse<List<BrandModel>>>> getBrands() async {

    return safeApiCall(
          () => _equipmentService.getBrand(),
            (json) {
          if (json == null) return <BrandModel>[];
          final list = json as List<dynamic>;
          return list.map((item) => BrandModel.fromJson(item as Map<String, dynamic>)).toList();
        }
    );
  }
  Future<Result<BaseResponse<List<CategoryModel>>>> getCategories(int id) async {

    return safeApiCall(
          () => _equipmentService.getByBrandIdCategories(id),
            (json) {
          if (json == null) return <CategoryModel>[];
          final list = json as List<dynamic>;
          return list.map((item) => CategoryModel.fromJson(item as Map<String, dynamic>)).toList();
        }
    );
  }

  // 2. Bitta uskuna tafsilotlarini olish
  // Future<Result<BaseResponse<EquipmentModel>>> getEquipmentDetails(int id) async {
  //   return safeApiCall(
  //         () => _equipmentService.getEquipments(),
  //         (json) => EquipmentModel.fromJson(json),
  //   );
  // }
}