import 'package:admin/features/profile/components/site_branding.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditingProfile = false; // Tahrirlash rejimini boshqarish
  bool isEditingSite = false; // Tahrirlash rejimini boshqarish

  // Foydalanuvchi ma'lumotlari uchun kontrollerlar
  final TextEditingController nameController = TextEditingController(text: "Ali Valiyev");
  final TextEditingController phoneController = TextEditingController(text: "+998 90 123 45 67");
  final TextEditingController roleController = TextEditingController(text: "Admin / Operator");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        actions: [
          // Tahrirlashni yoqish/o'chirish tugmasi
          IconButton(
            icon: Icon(isEditingSite ? Icons.close : Icons.edit),
            onPressed: () => setState(() => isEditingSite = !isEditingSite),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
            ),
            child:isEditingSite?SiteBrandingWidget(): Column(
              children: [
                // 1. PROFIL RASMI
                _buildProfileAvatar(),
                const SizedBox(height: 30),

                // 2. MA'LUMOTLAR RO'YXATI
                _buildProfileInfoRow("Ism sharif", nameController, Icons.person),
                const Divider(height: 30),
                _buildProfileInfoRow("Telefon raqam", phoneController, Icons.phone),
                const Divider(height: 30),
                _buildProfileInfoRow("Lavozim", roleController, Icons.badge),

                const SizedBox(height: 40),

                // 3. SAQLASH TUGMASI (Faqat tahrirlashda chiqadi)
                if (isEditingProfile)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => isEditingProfile = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Ma'lumotlar saqlandi!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text("Saqlash", style: TextStyle(color: Colors.white)),
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Profil rasmi qismi
  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.blue[50],
          child: const Icon(Icons.person, size: 70, color: Colors.blue),
        ),
        if (isEditingProfile)
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 18,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                onPressed: () {}, // Rasm o'zgartirish
              ),
            ),
          ),
      ],
    );
  }

  // Har bir ma'lumot qatori (Info row)
  Widget _buildProfileInfoRow(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: isEditingProfile
                  ? TextField(
                controller: controller,
                decoration: const InputDecoration(isDense: true, border: UnderlineInputBorder()),
              )
                  : Text(
                controller.text,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            if (!isEditingProfile)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                onPressed: () => setState(() => isEditingProfile = true),
              ),
          ],
        ),
      ],
    );
  }
}