import 'dart:async';

import 'package:admin/network/response_base.dart';
import 'package:chopper/chopper.dart';

import 'model_response.dart';
class ResultConverter extends JsonConverter {
  @override
  FutureOr<Response<ResultType>> convertResponse<ResultType, Item>(Response response) async {
    final jsonResponse = await super.convertResponse<dynamic, Item>(response);
    final Map<String, dynamic> body = jsonResponse.body;

    // 1. Backend-dan kelgan isSuccess maydonini tekshiramiz
    final bool isSuccess = body['isSuccess'] ?? false;

    if (isSuccess) {
      // 2. Muvaffaqiyatli bo'lsa, BaseResponse-ni yaratamiz
      // Item bu biz kutayotgan model (masalan Equipment)
      final apiResponse = BaseResponse<ResultType>.fromJson(
        body,
            (data) => data as ResultType, // Bu yerda data qismini o'z holicha olamiz
      );

      return response.copyWith<ResultType>(
        body: Success(apiResponse) as ResultType,
      );
    } else {
      // 3. isSuccess false bo'lsa, backend-dagi message-ni Failure ichiga solamic
      return response.copyWith<ResultType>(
        body: Error(Exception(body['message'] ?? "Xatolik")) as ResultType,
      );
    }
  }
}