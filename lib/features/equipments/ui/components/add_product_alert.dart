import 'package:admin/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/custom_field.dart';
import '../providers/repository_provider.dart';
import '../providers/widgets/image_list_picker.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({Key? key}) : super(key: key);

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  String condition = "Yangi"; // Mahsulot holati
  final nameController = TextEditingController();
  final modelController = TextEditingController();
  final detailsController = TextEditingController();
  final pricePerDayController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController(text: "1");
  bool isMainProduct = true;
  bool hasAccessories = true;
  @override
  Widget build(BuildContext context) {
    final equipmentProvider = Provider.of<EquipmentProvider>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Yangi mahsulot qo'shish",
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 850, // Web uchun kengaytirilgan oyna
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageListPicker(),
                const SizedBox(height: 25),

                // 2. BREND VA KATEGORIYA (Yonma-yon)
                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyDropdown(
                          "Brend", equipmentProvider.selectedBrand?.name),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildReadOnlyDropdown("Kategoriya",
                          equipmentProvider.selectedCategory?.name),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // 3. MAHSULOT NOMI VA SKU (ID)
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: CustomTextField(
                          label: "Mahsulot nomi",
                          icon: Icons.inventory_2,
                          controller: nameController,
                        )),
                    const SizedBox(width: 15),
                    Expanded(
                        flex: 1,
                        child: CustomTextField(
                          label: "ID / SKU",
                          icon: Icons.qr_code,
                          controller: modelController,
                        )),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: CustomTextField(
                          label: "Ijara narxi(kunlik)",
                          icon: Icons.price_change,
                          controller: pricePerDayController,
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            ThousandSeparatorFormatter(),
                          ],
                          suffix: "So'm",
                        )),
                    const SizedBox(width: 15),
                    Expanded(
                        flex: 1,
                        child: CustomTextField(
                          label: "Narxi",
                          icon: Icons.monetization_on_outlined,
                          controller: priceController,
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            ThousandSeparatorFormatter()
                          ],
                          suffix: "So'm",
                        )),
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Mahsulot turi",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Asosiy mahsulot tanlovi
                        ChoiceChip(
                          label: const Text("Asosiy mahsulot"),
                          selected: isMainProduct,
                          selectedColor: Colors.blue.withOpacity(0.2),
                          labelStyle: TextStyle(
                              color:
                                  isMainProduct ? Colors.blue : Colors.black),
                          onSelected: (selected) {
                            if (selected) setState(() => isMainProduct = true);
                          },
                        ),
                        const SizedBox(width: 12),

                        // Qo'shimcha mahsulot tanlovi
                        ChoiceChip(
                          label: const Text("Qo'shimcha"),
                          selected: !isMainProduct,
                          selectedColor: Colors.orange.withOpacity(0.2),
                          labelStyle: TextStyle(
                              color: !isMainProduct
                                  ? Colors.orange
                                  : Colors.black),
                          onSelected: (selected) {
                            if (selected) setState(() => isMainProduct = false);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                // 4. NARXI VA SONI (STOCK)

                const SizedBox(height: 15),

                // 5. MAHSULOT HAQIDA (DESCRIPTION)
                CustomTextField(
                  label: "Soni",
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                  icon: Icons.description,
                  maxLines: 1,
                  controller: quantityController,
                ),
                const SizedBox(height: 15),

                // 5. MAHSULOT HAQIDA (DESCRIPTION)
                CustomTextField(
                  label: "Mahsulot haqida batafsil",
                  icon: Icons.description,
                  maxLines: 3,
                  controller: detailsController,
                ),
                const SizedBox(height: 15),
                const Text("Qo'shimcha parametrlar",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                _buildCheckbox("Aksessuarlar mavjud"),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Bekor qilish")),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
          child: const Text("Saqlash"),
        ),
      ],
    );
  }

  Widget _buildReadOnlyDropdown(String label, String? selectedValue) {
    final bool isError = selectedValue == null || selectedValue.isEmpty;

    return DropdownButtonFormField<String>(
      value: isError ? null : selectedValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isError ? Colors.red : Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isError ? Colors.red : Colors.green[300]!,
            width: isError ? 2.0 : 1.0,
          ),
        ),
      ),
      onChanged: null, // Read-only qilish uchun

      hint: isError
          ? const Text("Tanlanmagan!", style: TextStyle(color: Colors.red))
          : null,

      items: isError
          ? []
          : [
              DropdownMenuItem(value: selectedValue, child: Text(selectedValue))
            ],
    );
  }

  Widget _buildCheckbox(String label) {
    return StatefulBuilder(builder: (context, setStateCB) {
      return Row(
        children: [
          Checkbox(
              value: hasAccessories,
              onChanged: (v) => setStateCB(() => hasAccessories = v!)),
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 15),
        ],
      );
    });
  }
}
