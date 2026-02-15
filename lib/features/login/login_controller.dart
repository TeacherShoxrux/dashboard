// import 'dart:async';
//
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// // Bu qator kod generatsiyasi uchun shart!
// // Fayl nomi bilan bir xil bo'lishi kerak.
// part 'login_controller.g.dart';
//
// @riverpod
// class LoginController extends _$LoginController {
//   @override
//   FutureOr<void> build() {
//     // Boshlang'ich holat: hech qanday yuklanish yoki xato yo'q.
//     return null;
//   }
//
//   Future<void> login(String email, String password) async {
//     // 1. Holatni yuklanishga o'tkazamiz 🔄
//     state = const AsyncLoading();
//
//     // 2. Login jarayonini bajaramiz
//     state = await AsyncValue.guard(() async {
//       // Bu yerda API chaqiruvi bo'ladi
//       await Future.delayed(const Duration(seconds: 2));
//
//       // Agar login xato bo'lsa, xatolikni shu yerda tashlaymiz (throw)
//       // throw Exception("Email yoki parol noto'g'ri!");
//     });
//   }
// }