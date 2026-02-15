import 'dart:async';

import 'package:chopper/chopper.dart';

class AuthInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    // return chain.proceed(chain.request);
    final request = chain.request;
    final newRequest = request.copyWith(headers: {
      ...request.headers,
      // 'Authorization': 'Bearer YOUR_SECRET_TOKEN', // .NET uchun token
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // 4. So'rovni davom ettiring
    return chain.proceed(newRequest);
  }
}