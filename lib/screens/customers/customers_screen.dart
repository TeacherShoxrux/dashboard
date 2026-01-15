import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool isAddingNew = false; // Ro'yxat yoki Forma ko'rinishini almashtirish

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sarlavha va Tugma
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAddingNew ? "Yangi mijoz qo'shish" : "Mijozlar ro'yxati",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => isAddingNew = !isAddingNew),
                  icon: Icon(isAddingNew ? Icons.list : Icons.add),
                  label: Text(isAddingNew ? "Ro'yxatga qaytish" : "Yangi mijoz"),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Dinamik kontent: Yoki Jadval yoki Forma
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: isAddingNew ? _buildAddCustomerForm() : _buildCustomerTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1-Rasm: Mijoz qo'shish formasi
  Widget _buildAddCustomerForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildTextField("Passport seriyasi", "Seriyani kiriting")),
              SizedBox(width: 20),
              Expanded(child: _buildTextField("Passport raqami", "Raqamni kiriting")),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTextField("Yashash manzili", "Manzilni kiriting")),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Passport bormi?", style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Radio(value: true, groupValue: true, onChanged: (v) {}), Text("Bor"),
                        Radio(value: false, groupValue: true, onChanged: (v) {}), Text("Yo'q"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTextField("Izoh", "Qo'shimcha ma'lumot...", maxLines: 3),
          SizedBox(height: 30),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Saqlash"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: Size(150, 50)),
            ),
          )
        ],
      ),
    );
  }

  // 2-Rasm: Mijozlar jadvali
  Widget _buildCustomerTable() {
    return ListView(
      children: [
        DataTable(
          // headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Ismi Familiyasi')),
            DataColumn(label: Text('Passport')),
            DataColumn(label: Text('Holati')),
            DataColumn(label: Text('Amallar')),
          ],
          rows: List.generate(5, (index) => DataRow(cells: [
            DataCell(Text("${17 - index}")),
            DataCell(Text("Rustam Axmerov")),
            DataCell(Text("AD32131231")),
            DataCell(Row(children: [Icon(Icons.check_circle, color: Colors.green, size: 16), Text(" Aktiv")])),
            DataCell(Row(
              children: [
                IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () {}),
              ],
            )),
          ])),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }
}