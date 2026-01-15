import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            // Webda oyna kengligini cheklash (Responsive)
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20),
              ],
            ),
            child: Column(
              children: [
                // 1. PROFIL RASMI (EDITABLE)
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue[100],
                      backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: () {
                            // Rasm yuklash funksiyasi
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 2. SHAXSIY MA'LUMOTLAR
                _buildSectionTitle("Shaxsiy ma'lumotlar"),
                const SizedBox(height: 15),
                _buildTextField(label: "Ism sharif", icon: Icons.person, hint: "Ali Valiyev"),
                const SizedBox(height: 15),
                _buildTextField(label: "Telefon raqam", icon: Icons.phone, hint: "+998 90 123 45 67"),

                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),

                // 3. PAROLNI O'ZGARTIRISH
                _buildSectionTitle("Parolni yangilash"),
                const SizedBox(height: 15),
                _buildTextField(
                  label: "Yangi parol",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  label: "Parolni tasdiqlash",
                  icon: Icons.lock_reset,
                  isPassword: true,
                  obscureText: true,
                ),

                const SizedBox(height: 40),

                // 4. SAQLASH TUGMASI
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("O'zgarishlarni saqlash", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Yordamchi vidjetlar
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    String? hint,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}