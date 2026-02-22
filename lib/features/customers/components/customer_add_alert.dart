import 'package:admin/core/custom_field.dart';
import 'package:admin/network/api_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/file_priveiw_widget.dart';
import '../../../core/widgets/file_uploader.dart';

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
  DateTime? dateOfBirth;

  var passportType = "Oddiy";
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passportSeriesNumController = TextEditingController();

  final jshshirController = TextEditingController();
  final noteController = TextEditingController();
  final addressController = TextEditingController();
  var isWoman = false;
  final isOriginalDocumentLeft = false;
  final List<String> files=[];
  String? image;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Yangi mijoz qo'shish"),
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close)),
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
                Row(
                  children: [
                    Expanded(
                        child: CustomTextField(
                            label: "Ism",
                            controller: firstNameController,
                            icon: Icons.person)),
                    const SizedBox(width: 15),
                    Expanded(
                        child: CustomTextField(
                            label: "Familiya",
                            controller: lastNameController,
                            icon: Icons.person_outline)),
                  ],
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown("Jinsi", ["Erkak", "Ayol"],
                          (val) => setState(() => isWoman = "Ayol" == val)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Passport bormi?",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: hasPassport,
                                  onChanged: (bool? v) =>
                                      setState(() => hasPassport = v!)),
                              const Text("Bor"),
                              Radio(
                                  value: false,
                                  groupValue: hasPassport,
                                  onChanged: (bool? v) =>
                                      setState(() => hasPassport = v!)),
                              const Text("Yo'q"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Passport turi",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          DropdownButtonFormField<String>(
                            value: passportType,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.assessment_outlined),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            items: ["Oddiy", "Zagran"].map((type) {
                              return DropdownMenuItem(
                                  value: type, child: Text(type));
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

                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                      Expanded(
                          child: CustomTextField(label: "JSHSHIR",icon:  Icons.numbers)),
                    SizedBox(width: 15),

                    Expanded(
                        child:CustomTextField(label:
                            "Passport Seriya va Raqam",icon:  Icons.badge)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePicker("Tug'ilgan kun"),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                        child: CustomTextField(
                          label:
                            "Taklif qilgan odam",icon:  Icons.card_giftcard)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text("Telefon raqamlari",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (String val) {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: CustomTextField(
                          label:
                            "O'zining telefon raqami", icon:  Icons.phone)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),

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
                            SizedBox(
                              width: 120,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Kimniki?",
                                  hintText: "Masalan: Akasi",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onChanged: (val) =>
                                    extraPhones[index].label = val,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Telefon raqami
                            Expanded(
                              child: CustomTextField(
                                label:
                                "Telefon raqami",
                              icon:   Icons.phone_android,
                                // controller: extraPhones[index].controller, // Controllerni bog'laysiz
                              ),
                            ),
                            // O'chirish tugmasi
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              onPressed: () =>
                                  setState(() => extraPhones.removeAt(index)),
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
                CustomTextField(label: "Details (Batafsil ma'lumot)",icon:  Icons.description,
                    maxLines: 2),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    if(image==null)FileUploader(
                      icon: Icon(Icons.add_a_photo,),
                      type: FileType.image,
                      label: "User Photo",
                      uploader: (String filePath) {
                        image=filePath;
                        setState(() {

                        });
                      },),
                    if(image!=null)FilePreviewCard(fileName: image!, localPath:ApiConstants.baseUrl+image!, onRemove: () { image=null;setState(() {
                    }); },),

                  ],
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: files.length+1,
                    itemBuilder: (context, index) {
                      if (index == files.length) {
                        return FileUploader(
                          type: FileType.any,
                          uploader: (String filePath) {
                            files.add(filePath);
                            setState(() {

                            });
                            },);
                      }
                      final file = files[index];
                      return FilePreviewCard(
                        fileName: file,
                        localPath:ApiConstants.baseUrl+ file, // Agar endi tanlangan bo'lsa
                        onRemove: () {
                          setState(() => files.removeAt(index));
                        },
                      );
                    },
                  ),
                )
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
              // Saqlash logikasi
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: const Text("Mijozni saqlash"),
        ),
      ],
    );
  }

  // Yordamchi metodlar
  Widget _buildField(String label, IconData icon,
      {bool isNumber = false, int maxLines = 1, String? hint}) {
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

  Widget _buildDropdown(
      String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
        if (picked != null) setState(() => dateOfBirth = picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: const Icon(Icons.calendar_today, size: 20),
          isDense: true,
        ),
        child: Text(dateOfBirth == null
            ? "Tanlang"
            : "${dateOfBirth!.day}.${dateOfBirth!.month}.${dateOfBirth!.year}"),
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
