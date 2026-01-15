import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBrand; // Tanlangan brendni saqlash uchun

  // Namunaviy brendlar ro'yxati (Buni backenddan olishingiz mumkin)
  final List<String> brands = ["Sony", "Apple", "Canon", "Nikon", "DJI"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Yangi kategoriya", style: TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. KATEGORIYA RASMI
                Center(
                  child: GestureDetector(
                    onTap: () { /* Rasm yuklash logikasi */ },
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.orange.shade100),
                      ),
                      child: const Icon(Icons.category_outlined,
                          size: 40, color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text("Kategoriya ikonkasini tanlang",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                const SizedBox(height: 25),

                // 2. BRENDNI TANLASH (DROPDOWN)
                const Text("Tegishli brend", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedBrand,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.business, color: Colors.orange),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    hintText: "Brendni tanlang",
                  ),
                  items: brands.map((String brand) {
                    return DropdownMenuItem<String>(
                      value: brand,
                      child: Text(brand),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedBrand = value),
                  validator: (value) => value == null ? "Brendni tanlash shart" : null,
                ),
                const SizedBox(height: 20),

                // 3. KATEGORIYA NOMI
                const Text("Kategoriya nomi", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Masalan: Fotoapparatlar, Obyektivlar...",
                    prefixIcon: const Icon(Icons.label_important_outline, color: Colors.orange),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value!.isEmpty ? "Nom kiritish shart" : null,
                ),
                const SizedBox(height: 20),

                // 4. KATEGORIYA HAQIDA
                const Text("Tavsif", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Ushbu kategoriya haqida qisqacha...",
                    prefixIcon: const Icon(Icons.notes, color: Colors.orange),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("Bekor qilish"),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Saqlash mantiqi
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("Saqlash"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}