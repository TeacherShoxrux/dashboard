import 'package:flutter/material.dart';

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({Key? key}) : super(key: key);

  @override
  _AddCustomerDialogState createState() => _AddCustomerDialogState();
}
class PhoneContact {
  String label; // Akasi, do'sti va h.k.
  TextEditingController controller;

  PhoneContact({required this.label, required this.controller});
}
class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();


// State ichida:
  List<PhoneContact> extraPhones = [];

  void _addPhoneField() {
  setState(() {
  extraPhones.add(PhoneContact(
  label: "", // Foydalanuvchi o'zi yozadi
  controller: TextEditingController(),
  ));
  });
  }
  // Ma'lumotlar holati
  String gender = "Erkak";
  bool hasPassport = true;
  DateTime? birthDate;

  var passportType="Oddiy";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Yangi mijoz qo'shish"),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width > 900 ? 800 : double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. ASOSIY MA'LUMOTLAR
                Row(
                  children: [
                    Expanded(child: _buildField("Ism", Icons.person)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Familiya", Icons.person_outline)),
                  ],
                ),
                const SizedBox(height: 15),

                // 2. JINSI VA PASSPORT HOLATI
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown("Jinsi", ["Erkak", "Ayol"], (val) => setState(() => gender = val!)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Passport bormi?", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Row(
                            children: [
                              Radio(value: true, groupValue: hasPassport, onChanged: (bool? v) => setState(() => hasPassport = v!)),
                              const Text("Bor"),
                              Radio(value: false, groupValue: hasPassport, onChanged: (bool? v) => setState(() => hasPassport = v!)),
                              const Text("Yo'q"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 3. JSHSHIR VA PASSPORT SERIYA
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _buildField("JSHSHIR", Icons.numbers, isNumber: true)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Passport Seriya va Raqam", Icons.badge)),
                  ],
                ),

                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Passport turi", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          DropdownButtonFormField<String>(
                            value: passportType,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.assessment_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            items: ["Oddiy", "Zagran"].map((type) {
                              return DropdownMenuItem(value: type, child: Text(type));
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                passportType = val!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Agar Zagran bo'lsa, qo'shimcha field chiqadi, aks holda JSHSHIR turadi
                    Expanded(
                      child: passportType == "Zagran"
                          ? _buildField("Passport haqida (Qo'shimcha)", Icons.info_outline)
                          : _buildField("JSHSHIR", Icons.numbers, isNumber: true),
                    ),
                  ],
                ),

                // 4. PASSPORT SERIYA VA RAQAM (Alohida qatorda yoki yonida)
                const SizedBox(height: 15),
                Row(
                  children: [
                    // Agar tepada JSHSHIRni zagranga almashtirgan bo'lsak, bu yerda JSHSHIRni ko'rsatish mumkin
                    if (passportType == "Zagran")
                      Expanded(child: _buildField("JSHSHIR", Icons.numbers, isNumber: true)),
                    if (passportType == "Zagran") const SizedBox(width: 15),

                    Expanded(child: _buildField("Passport Seriya va Raqam", Icons.badge)),
                  ],
                ),

                // 4. TUG'ILGAN KUN VA INVITE ID
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePicker("Tug'ilgan kun"),
                    ),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Taklif qilgan odam", Icons.card_giftcard)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text("Telefon raqamlari", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "O'zini",
                          hintText: "O'zini",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (String val) {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: _buildField("O'zining telefon raqami", Icons.phone, hint: "+998")),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () {},
                    ),

                  ],
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //
                //   ],
                // ),
// Dinamik qo'shiladigan raqamlar
                if (extraPhones.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true, // Scroll ichida ishlashi uchun
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: extraPhones.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            // Kimga tegishliligi (Akasi, do'sti...)
                            SizedBox(
                              width: 120,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Kimniki?",
                                  hintText: "Masalan: Akasi",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onChanged: (val) => extraPhones[index].label = val,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Telefon raqami
                            Expanded(
                              child: _buildField(
                                "Telefon raqami",
                                Icons.phone_android,
                                hint: "+998",
                                // controller: extraPhones[index].controller, // Controllerni bog'laysiz
                              ),
                            ),
                            // O'chirish tugmasi
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => setState(() => extraPhones.removeAt(index)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 5),

                TextButton.icon(
                  onPressed: _addPhoneField,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Boshqa raqam qo'shish"),
                ),

                const SizedBox(height: 15),
                _buildField("Details (Batafsil ma'lumot)", Icons.description, maxLines: 2),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildUploadButton(Icons.add_a_photo, "User Photo"),
                    _buildUploadButton(Icons.file_copy, "Documents (PDF/JPG)"),
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
              // Saqlash logikasi
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: const Text("Mijozni saqlash"),
        ),
      ],
    );
  }

  // Yordamchi metodlar
  Widget _buildField(String label, IconData icon, {bool isNumber = false, int maxLines = 1, String? hint}) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker(String label) {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => birthDate = picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: const Icon(Icons.calendar_today, size: 20),
          isDense: true,
        ),
        child: Text(birthDate == null ? "Tanlang" : "${birthDate!.day}.${birthDate!.month}.${birthDate!.year}"),
      ),
    );
  }

  Widget _buildUploadButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          onPressed: () {}, // File picker logic
          icon: Icon(icon, color: Colors.blue, size: 30),
        ),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}