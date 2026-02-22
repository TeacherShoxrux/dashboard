import 'package:admin/features/equipments/domain/models/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../network/api_constants.dart';
import '../providers/repository_provider.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  BrandModel? selectedBrand; // Tanlangan brendni saqlash uchun
  final nameController = TextEditingController();
  final detailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final equipmentProvider = Provider.of<EquipmentProvider>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Yangi kategoriya",
              style: TextStyle(fontWeight: FontWeight.bold)),
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
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: equipmentProvider.imagePath != null
                              ? DecorationImage(
                                  image: NetworkImage(ApiConstants.baseUrl +
                                      equipmentProvider.imagePath!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: equipmentProvider.pickedFileBytes != null
                            ? null
                            : const Icon(Icons.add_photo_alternate_outlined,
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
                            icon: const Icon(Icons.add,
                                color: Colors.white, size: 20),
                            onPressed: () {
                              context
                                  .read<EquipmentProvider>()
                                  .pickEquipmentImage();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text("Kategoriya ikonkasini tanlang",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                const SizedBox(height: 25),

                // 2. BRENDNI TANLASH (DROPDOWN)
                const Text("Tegishli brend",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // DropdownButtonFormField<BrandModel>(
                //   value: selectedBrand,
                //   decoration: InputDecoration(
                //     prefixIcon: const Icon(Icons.business, color: Colors.orange),
                //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                //     hintText: "Brendni tanlang",
                //   ),
                //   items: equipmentProvider.brands.map((brand) {
                //     return DropdownMenuItem<BrandModel>(
                //       value: brand,
                //       child: Text(brand.name),
                //     );
                //   }).toList(),
                //   onChanged: (value) => setState(() => selectedBrand = value),
                //   validator: (value) => value == null ? "Brendni tanlash shart" : null,
                // ),
                // const SizedBox(height: 20),

                // 3. KATEGORIYA NOMI
                const Text("Kategoriya nomi",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Masalan: Fotoapparatlar, Obyektivlar...",
                    prefixIcon: const Icon(Icons.label_important_outline,
                        color: Colors.orange),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Nom kiritish shart" : null,
                ),
                const SizedBox(height: 20),
                const Text("Tavsif",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: detailController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Ushbu kategoriya haqida qisqacha...",
                    prefixIcon: const Icon(Icons.notes, color: Colors.orange),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("Bekor qilish"),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var result = await equipmentProvider.addCategory(
                          equipmentProvider.selectedBrand!.id,
                          nameController.text,
                          detailController.text,
                          equipmentProvider.imagePath);
                      await Future.delayed(Duration(seconds: 2));
                      if (result == true) Navigator.pop(context, result);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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
