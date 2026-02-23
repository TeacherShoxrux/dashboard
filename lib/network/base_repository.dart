import 'package:admin/network/response_base.dart';
import 'package:chopper/chopper.dart';
import 'model_response.dart';
import 'dart:developer' as dev;

mixin BaseRepository {
  Future<BaseResponse<T>> safeApiCall<T>(
    Future<Response> Function() call,
    T Function(dynamic) mapper,
  ) async {
    try {
      dev.log('===> API so\'rovi boshlandi', name: 'REPO');
      final response = await call();
      dev.log('===>================================ API so\'rov tugadi',
          name: 'REPO');
      dev.log(response.runtimeType.toString());

      if (response.body is Success) {
        final Map<String, dynamic> rawJson = (response.body as Success).value;
        final apiResponse =
            BaseResponse<T>.fromJson(rawJson, (data) => mapper(data));
        return apiResponse;
      }
      return BaseResponse<T>.fromJson(response.body, (data) => mapper(data));
    } catch (e) {
      dev.log('===> KUTILMAGAN XATO: $e', name: 'REPO', error: e);
      rethrow;
    }
  }
}
