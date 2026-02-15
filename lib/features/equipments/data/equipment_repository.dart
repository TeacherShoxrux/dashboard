
import '../../../network/base_repository.dart';
import '../../../network/model_response.dart';
import '../../../network/response_base.dart';
import '../../cart/components/equipment_autocomplete.dart';
import '../../cart/equipment_search.dart';
import '../domain/models/equipment_model.dart';
import 'equipment_service.dart';

class EquipmentRepository extends BaseRepository {
  final EquipmentService _equipmentService;

  EquipmentRepository(this._equipmentService);

  // 1. Barcha uskunalar ro'yxatini olish (Pagination bilan)
  Future<Result<BaseResponse<List<EquipmentModel>>>> getEquipments() async {

    return safeApiCall(
          () => _equipmentService.getEquipments(),
            (json) {
          if (json == null) return <EquipmentModel>[];
          final list = json as List<dynamic>;

          return list.map((item) => EquipmentModel.fromJson(item as Map<String, dynamic>)).toList();
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