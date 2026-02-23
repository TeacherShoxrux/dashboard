import 'package:admin/core/custom_field.dart';
import 'package:admin/features/customers/models/customer_create_model.dart';
import 'package:admin/features/customers/provider/file_uploader_notifier.dart';
import 'package:admin/network/api_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/file_priveiw_widget.dart';
import '../../../core/widgets/file_uploader.dart';
import '../provider/customer_notifier.dart';
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
  List<PhoneRequestModel> phones = [
    PhoneRequestModel(
      name: "O'ziniki",
      phoneNumber: '',
    )
  ];
  void _addPhoneField() {
    setState(() {
      phones.add(PhoneRequestModel(
        name: "",
        phoneNumber: '',
      ));
    });
  }
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
  final List<String> files = [];
  String? image;
  @override
  Widget build(BuildContext context) {
    final customerProvider =
        Provider.of<CustomerNotifierProvider>(context, listen: false);
    final fileProvider = Provider.of<FileUploaderNotifier>(context, listen: false);
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
                            validator: (value) =>
                                AppValidators.required(value, "Ism kiriting"),
                            label: "Ism",
                            controller: firstNameController,
                            icon: Icons.person)),
                    const SizedBox(width: 15),
                    Expanded(
                        child: CustomTextField(
                            validator: (value) => AppValidators.required(
                                value, "Familya kiriting"),
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
                        child: CustomTextField(
                            validator: AppValidators.price,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: jshshirController,
                            label: "JSHSHIR",
                            icon: Icons.numbers)),
                    SizedBox(width: 15),
                    Expanded(
                        child: CustomTextField(
                            controller: passportSeriesNumController,
                            validator: (c) => AppValidators.required(
                                c, "Passport Seriya va Raqam kiriting"),
                            label: "Passport Seriya va Raqam",
                            icon: Icons.badge)),
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
                            label: "Taklif qilgan odam",
                            icon: Icons.card_giftcard)),
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
                        onChanged: (String val) {
                          phones.first.phoneNumber = val;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: CustomTextField(
                            label: "O'zining telefon raqami",
                            validator: AppValidators.phone,
                            icon: Icons.phone)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
                if (phones.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true, // Scroll ichida ishlashi uchun
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: phones.length - 1,
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
                                validator: (e) => AppValidators.required(
                                    e, "Kiritishda xatolik"),
                                onChanged: (val) =>
                                    phones[index + 1].name = val,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                label: "Telefon raqami",
                                icon: Icons.phone_android,
                                onChange: (phone) {
                                  phones[index + 1].name = phone;
                                },
                                validator: AppValidators.phone,
                              ),
                            ),
                            // O'chirish tugmasi
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              onPressed: () =>
                                  setState(() => phones.removeAt(index + 1)),
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
                CustomTextField(
                  controller: noteController,
                    validator: (e)=>AppValidators.required(e, "Biror bir ma'lumot kiriting"),
                    label: "Details (Batafsil ma'lumot)",
                    icon: Icons.description,
                    maxLines: 2),
                const SizedBox(height: 20),
                Divider(),
                Text("User foto"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (image == null)
                      FileUploader(
                        icon: Icon(
                          Icons.add_a_photo,
                        ),
                        type: FileType.image,
                        label: "User Photo",
                        uploader: (String filePath) {
                          image = filePath;
                          setState(() {});
                        },
                      ),
                    if (image != null)
                      FilePreviewCard(
                        fileName: image!,
                        localPath: ApiConstants.baseUrl + image!,
                        onRemove: () {
                          image = null;
                          setState(() {});
                        },
                      ),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text("Hujjatlar yuklash"),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: files.length + 1,
                    itemBuilder: (context, index) {
                      if (index == files.length) {
                        return FileUploader(
                          type: FileType.any,
                          uploader: (String filePath) {
                            files.add(filePath);
                            setState(() {});
                          },
                        );
                      }
                      final file = files[index];
                      return FilePreviewCard(
                        fileName: file,
                        localPath: ApiConstants.baseUrl + file,
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
          onPressed: () async {
            print("model is valid valid 1");
            if (_formKey.currentState!.validate()) {
              print("model is valid valid 2");
                var reuult= await customerProvider.addCustomer(CustomerCreateModel(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    dateOfBirth: dateOfBirth!,
                    passportSeries:
                        passportSeriesNumController.text.substring(0, 2),
                    passportNumber:
                        passportSeriesNumController.text.substring(2),
                    jShShir: jshshirController.text,
                    isWoman: isWoman,
                    isOriginalDocumentLeft: isOriginalDocumentLeft,
                    documentScans: files,
                    address: addressController.text,
                    note: noteController.text,
                    userPhotoUrl: image,
                    phones: phones));
                if(reuult==true){
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pop(context,reuult);
                }
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: const Text("Mijozni saqlash"),
        ),
      ],
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
}
