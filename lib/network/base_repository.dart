import 'package:admin/network/response_base.dart';
import 'package:chopper/chopper.dart';
import 'model_response.dart';
import 'dart:developer' as dev;
abstract class BaseRepository {
  /// [safeApiCall] - API so'rovlarini xavfsiz bajarish va [Result]ga o'rash uchun.
  /// [T] - Bu biz kutayotgan Model tipi (masalan, Equipment).
  Future<Result<BaseResponse<T>>> safeApiCall<T>(
      Future<Response> Function() call,
      T Function(dynamic) mapper,
      ) async {
    try {
      dev.log('===> API so\'rovi boshlandi', name: 'REPO');
      final response = await call();
      dev.log('===>================================ API so\'rov tugadi', name: 'REPO');
     dev.log(response.runtimeType.toString());

      if (response.body is Success) {
        final Map<String, dynamic> rawJson = (response.body as Success).value;

        // BaseResponse ichidagi mapper aynan Modelni (T) yaratish uchun xizmat qiladi
        final apiResponse = BaseResponse<T>.fromJson(
          rawJson,
              (data) => mapper(data), // Bu yerda mapper(data) - EquipmentModel.fromJson()
        );

        return Success(apiResponse);
    }
      return Error(Exception(response.body.toString()));
    }catch (e) {
      dev.log('===> KUTILMAGAN XATO: $e', name: 'REPO', error: e);
      return Error(Exception("Server bilan aloqa xatosi: $e"));
    }
  }
}