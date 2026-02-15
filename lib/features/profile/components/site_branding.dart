import 'package:flutter/material.dart';

class SiteBrandingWidget extends StatefulWidget {
  const SiteBrandingWidget({super.key});

  @override
  State<SiteBrandingWidget> createState() => _SiteBrandingWidgetState();
}

class _SiteBrandingWidgetState extends State<SiteBrandingWidget> {
  final TextEditingController _siteNameController =
  TextEditingController(text: "Mening Ijaram");

  // Haqiqiy ilovada bu fayl yo'li yoki URL bo'ladi
  String logoPath = "https://via.placeholder.com/150";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Brending sozlamalari",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),

          // LOGOTIP QISMI
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      // color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      image: DecorationImage(
                        image: NetworkImage(logoPath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: InkWell(
                      onTap: () {
                        // Bu yerda file_picker yoki image_picker chaqiriladi
                        print("Logo o'zgartirish bosildi");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Veb-sayt logotipi",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5),
                    const Text(
                      "Tavsiya etilgan o'lcham: 512x512px. PNG yoki SVG format.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text("Logotipni o'chirish"),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // SAYT NOMI QISMI
          const Text("Veb-sayt nomi",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          TextField(
            controller: _siteNameController,
            decoration: InputDecoration(
              hintText: "Sayt nomini kiriting",
              prefixIcon: const Icon(Icons.language),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              // fillColor: Colors.grey[50],
            ),
          ),

          const SizedBox(height: 25),

          // SAQLASH TUGMASI
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Backendga (ASP.NET Core) yuborish mantiqi
                print("Yangi sayt nomi: ${_siteNameController.text}");
              },
              child: const Text("O'zgarishlarni saqlash"),
            ),
          ),
        ],
      ),
    );
  }
}