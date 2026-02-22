import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../network/api_constants.dart';
import '../providers/repository_provider.dart';

class AddBrandDialog extends StatefulWidget {
  const AddBrandDialog({Key? key}) : super(key: key);

  @override
  _AddBrandDialogState createState() => _AddBrandDialogState();
}

class _AddBrandDialogState extends State<AddBrandDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final equipmentProvider=Provider.of<EquipmentProvider>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Yangi brend qo'shish", style: TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.grey),
          ),
        ],
      ),
      content: SizedBox(
        width: 450, // Webda ixcham ko'rinishi uchun
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. BREND RASMI / LOGOTIPI
                Center(
                  child: Stack(
                    children: [

                        Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: equipmentProvider.imagePath!=null? DecorationImage(
                            image: NetworkImage(ApiConstants.baseUrl+equipmentProvider.imagePath!),
                            fit: BoxFit.cover,
                          ):null,
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child:equipmentProvider.pickedFileBytes!=null?null:
                        const Icon(Icons.add_photo_alternate_outlined,
                            size: 40, color: Colors.blue),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.add, color: Colors.white, size: 20),
                            onPressed: () {
                              context.read<EquipmentProvider>().pickEquipmentImage();

                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text("Brend logotipini yuklang",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                const SizedBox(height: 25),

                // 2. BREND NOMI
                const Text("Brend nomi", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _brandNameController,
                  decoration: InputDecoration(
                    hintText: "Masalan: Apple, Sony, Canon...",
                    prefixIcon: const Icon(Icons.business),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value!.isEmpty ? "Nom kiritish majburiy" : null,
                ),
                const SizedBox(height: 20),

                // 3. BREND HAQIDA (DESCRIPTION)
                const Text("Brend haqida ma'lumot", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Brendning faoliyat turi yoki qisqacha tarixi...",
                    prefixIcon: const Icon(Icons.description_outlined),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Bekor qilish"),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Backendga yuborish
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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