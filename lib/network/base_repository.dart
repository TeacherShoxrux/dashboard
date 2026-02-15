import 'package:admin/network/response_base.dart';
import 'package:chopper/chopper.dart';
import 'model_response.dart';

abstract class BaseRepository {
  /// [safeApiCall] - API so'rovlarini xavfsiz bajarish va [Result]ga o'rash uchun.
  /// [T] - Bu biz kutayotgan Model tipi (masalan, Equipment).
  Future<Result<BaseResponse<T>>> safeApiCall<T>(
      Future<Response> Function() call,
      T Function(dynamic) mapper,
      ) async {
    try {
      // 1. API so'rovini yuboramiz
      final response = await call();

      // 2. Chopper orqali kelgan Result-ni tekshiramiz
      // Biz ResultConverter ishlatganimiz uchun response.body allaqachon Result tipida bo'ladi
      if (response.body is Success) {
        final successData = response.body as Success;

        // .NET dan kelgan Wrapper-ni (isSuccess, data, message) tahlil qilamiz
        final apiResponse = BaseResponse<T>.fromJson(
          successData.value,
              (data) => mapper(data),
        );

        return Success(apiResponse);
      } else {
        // Agar Converter xatolik qaytargan bo'lsa (Failure)
        final failureData = response.body as Error;
        return Error(failureData.exception);
      }
    } catch (e) {
      // 3. Kutilmagan xatoliklar (masalan, JSON o'girishda xato)
      return Error(Exception("Kutilmagan xatolik: $e"));
    }
  }
}