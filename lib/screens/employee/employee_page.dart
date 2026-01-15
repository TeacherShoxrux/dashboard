import 'package:flutter/material.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({Key? key}) : super(key: key);

  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  bool isAdding = false;
  bool isObscure = true;

  // Kontrollerlar
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jshshirController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = "Operator";
  DateTime? birthDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sarlavha va Qo'shish tugmasi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAdding ? "Yangi xodim qo'shish" : "Xodimlar ro'yxati",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => isAdding = !isAdding),
                  icon: Icon(isAdding ? Icons.arrow_back : Icons.person_add),
                  label: Text(isAdding ? "Ro'yxatga qaytish" : "Xodim qo'shish"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdding ? Colors.grey : Colors.blue,
                    // foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Dinamik Kontent
            Expanded(
              child: isAdding ? _buildAddEmployeeForm() : _buildEmployeeTable(),
            ),
          ],
        ),
      ),
    );
  }

  // 1. XODIM QO'SHISH FORMASI
  Widget _buildAddEmployeeForm() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildInput("Ism Familiya", nameController, Icons.person)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildInput("JSHSHIR", jshshirController, Icons.featured_play_list, isNumber: true)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => birthDate = date);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Tug'ilgan kun",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.calendar_month),
                        ),
                        child: Text(birthDate == null ? "Sanani tanlang" : "${birthDate!.day}.${birthDate!.month}.${birthDate!.year}"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                        labelText: "Roli (Lavozimi)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.security),
                      ),
                      items: ["Admin", "Operator", "Manager"]
                          .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedRole = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildInput("Telefon raqam", phoneController, Icons.phone, hint: "+998")),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: passwordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        labelText: "Parol",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => isObscure = !isObscure),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Xodimni saqlash", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 2. XODIMLAR JADVALI
  Widget _buildEmployeeTable() {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: DataTable(
          headingRowHeight: 60,
          columns: const [
            DataColumn(label: Text('Xodim')),
            DataColumn(label: Text('JSHSHIR')),
            DataColumn(label: Text('Roli')),
            DataColumn(label: Text('Telefon')),
            DataColumn(label: Text('Amallar')),
          ],
          rows: List.generate(5, (index) => DataRow(cells: [
            const DataCell(Text("Asliddin Istamjonov")),
            const DataCell(Text("51406046920023")),
            DataCell(Chip(label: Text(index == 0 ? "Admin" : "Operator",style: TextStyle(color: index == 0 ? Colors.white : Colors.black)),backgroundColor: index == 0 ? Colors.purple : Colors.greenAccent)),
            const DataCell(Text("+998 90 123 45 67")),
            DataCell(Row(
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () {}),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () {}),
              ],
            )),
          ])),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon, {bool isNumber = false, String? hint}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}