import 'package:flutter/material.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({Key? key}) : super(key: key);

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

  // Tanlovlar uchun o'zgaruvchilar
  String? selectedBrand;
  String? selectedCategory;
  String condition = "Yangi"; // Mahsulot holati

  // Namunaviy ma'lumotlar
  final List<String> brands = ["Sony", "Apple", "Canon", "DJI"];
  final Map<String, List<String>> categoriesByBrand = {
    "Sony": ["Fotoapparat", "Obyektiv", "Quloqchin"],
    "Apple": ["MacBook", "iPad", "iPhone"],
    "Canon": ["Fotoapparat", "Printer"],
    "DJI": ["Dron", "Stabilizator"],
  };
  bool isMainProduct = true; // State ichida
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Yangi mahsulot qo'shish", style: TextStyle(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 850, // Web uchun kengaytirilgan oyna
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. RASM YUKLASH QISMI (GALLERY)
                _buildImageUploadSection(),
                const SizedBox(height: 25),

                // 2. BREND VA KATEGORIYA (Yonma-yon)
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown("Brend", brands, (val) {
                        setState(() {
                          selectedBrand = val;
                          selectedCategory = null; // Brend o'zgarsa kategoriya tozalanadi
                        });
                      }),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildDropdown(
                        "Kategoriya",
                        selectedBrand == null ? [] : categoriesByBrand[selectedBrand]!,
                            (val) => setState(() => selectedCategory = val),
                        enabled: selectedBrand != null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // 3. MAHSULOT NOMI VA SKU (ID)
                Row(
                  children: [
                    Expanded(flex: 2, child: _buildField("Mahsulot nomi", Icons.inventory_2)),
                    const SizedBox(width: 15),
                    Expanded(flex: 1, child: _buildField("ID / SKU", Icons.qr_code)),
                  ],
                ),
                const SizedBox(height: 15),


// Mahsulot qo'shish formasi ichida:
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Mahsulot turi", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Row(
                children: [
                  // Asosiy mahsulot tanlovi
                  ChoiceChip(
                    label: const Text("Asosiy mahsulot"),
                    selected: isMainProduct,
                    selectedColor: Colors.blue.withOpacity(0.2),
                    labelStyle: TextStyle(color: isMainProduct ? Colors.blue : Colors.black),
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
                    labelStyle: TextStyle(color: !isMainProduct ? Colors.orange : Colors.black),
                    onSelected: (selected) {
                      if (selected) setState(() => isMainProduct = false);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Boshqa barcha fieldlar bir xil davom etaveradi
              _buildField("Mahsulot nomi", Icons.inventory),
              // ...
            ],
          ),
                // 4. NARXI VA SONI (STOCK)

                const SizedBox(height: 15),

                // 5. MAHSULOT HAQIDA (DESCRIPTION)
                _buildField("Mahsulot haqida batafsil", Icons.description, maxLines: 3),

                const SizedBox(height: 15),

                const Text("Qo'shimcha parametrlar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildCheckbox("Sug'urta talab etiladi"),
                    _buildCheckbox("Aksessuarlar mavjud"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Bekor qilish")),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
          child: const Text("Saqlash"),
        ),
      ],
    );
  }

  // Rasm yuklash uchun UI
  Widget _buildImageUploadSection() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            const Text("Mahsulot rasmlarini yuklang (PNG, JPG)", style: TextStyle(color: Colors.grey, fontSize: 12)),
            TextButton(onPressed: () {}, child: const Text("Fayl tanlash"))
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, IconData icon, {bool isNumber = false, int maxLines = 1, String? suffix}) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, {bool enabled = true}) {
    return DropdownButtonFormField<String>(
      value: items.contains(selectedCategory) || items.contains(selectedBrand) ? null : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
        enabled: enabled,
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCheckbox(String label) {
    bool val = false;
    return StatefulBuilder(builder: (context, setStateCB) {
      return Row(
        children: [
          Checkbox(value: val, onChanged: (v) => setStateCB(() => val = v!)),
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 15),
        ],
      );
    });
  }
}