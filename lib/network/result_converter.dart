import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:admin/network/response_base.dart';
import 'package:chopper/chopper.dart';

import 'model_response.dart';
class ResultConverter extends JsonConverter {
  @override
  FutureOr<Response<ResultType>> convertResponse<ResultType, Item>(Response response) async {

    final jsonResponse = await super.convertResponse<dynamic, Item>(response);
    final body = jsonResponse.body;

    if (body is Map<String, dynamic>) {
      final bool isSuccess = body['isSuccess'] ?? false;
      if (isSuccess) {
        final successResult = Success(body);

        return response.copyWith<ResultType>(
          body: successResult as ResultType, // Tiplarni moslashtirish uchun
        );
      } else {
        return response.copyWith<ResultType>(
          body: Error(Exception(body['message'] ?? "Xato yuz berdi")) as ResultType,
        );
      }
    }

    return response.copyWith<ResultType>(
      body: Error(Exception("Noto'g'ri JSON format")) as ResultType,
    );
  }
}