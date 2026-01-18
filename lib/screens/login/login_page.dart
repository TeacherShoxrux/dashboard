import 'package:admin/core/notification/top_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/loading/global_loading_notifier.dart';
import '../../core/notification/notification_provider.dart';
import '../../core/router/app_routes.dart';
import '../main_layout/main_layout.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _rememberMe = false;

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            // Webda oyna kengligini cheklash
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. LOGOTIP YOKI IKONKA
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_person, size: 50, color: Colors.blue),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Tizimga kirish",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Davom etish uchun ma'lumotlaringizni kiriting",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // 2. LOGIN (TELEFON YOKI ISM)
                  TextFormField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      labelText: "Login",
                      // labelStyle: const TextStyle(fontSize: 14,color: Colors.black),
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value!.isEmpty ? "Loginni kiriting" : null,
                  ),
                  const SizedBox(height: 16),

                  // 3. PAROL
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: "Parol",

                      // labelStyle: const TextStyle(fontSize: 14,color: Colors.black),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                            // setState(() => _isObscure = !_isObscure);
                        }

                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value!.isEmpty ? "Parolni kiriting" : null,
                  ),
                  const SizedBox(height: 12),

                  // 4. ESLAB QOLISH VA PAROLNI UNUTDINGIZMI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (e){}
                                // (val) => setState(() => _rememberMe = val!),
                          ),
                          const Text("Eslab qolish", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Parolni unutdingizmi?", style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 5. KIRISH TUGMASI
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          final loading = ref.read(globalLoadingProvider.notifier);
                          loading.show();
                          await Future.delayed(const Duration(seconds: 2));
                          loading.hide();
                          ref.read(notificationServiceProvider)
                              .show("Muvaffaqiyatli kirdinggiz",type: NotificationType.success);
                          await Future.delayed(const Duration(seconds: 1));
                          context.go(AppRoutes.dashboard);
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("KIRISH", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}