import 'package:admin/features/customers/provider/customer_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/customer_add_alert.dart';
import 'components/customer_search_widget.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context.read<CustomerNotifierProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerNotifierProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0,right: 24.0,top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                 "Yangi mijoz qo'shish",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) => const AddCustomerDialog(),
                    );
                  },
                  // onPressed: () => setState(() => isAddingNew = !isAddingNew),
                  icon: Icon(Icons.add),
                  label: Text("Yangi mijoz"),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomerSearchWidget(),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child:ListView(
                  children: [
                    DataTable(
                      columnSpacing: 20,
                      headingRowColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.3)),
                      columns: const [
                        DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Ismi Familiyasi', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Passport', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Holati', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Passport Joylashuvi', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Amallar', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: customerProvider.customers.map(
                              (index) {

                            bool isAtOffice = index.id % 2 == 0;

                            return DataRow(cells: [
                              DataCell(Text("${index.id}")),
                              DataCell(Text("${index.firstName} ${index.lastName}")),
                              DataCell(Text("${index.passportSeries.toUpperCase()} ${index.passportNumber}")),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 14),
                                      SizedBox(width: 4),
                                      Text("Aktiv", style: TextStyle(color: Colors.green, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Text(
                                      index.isOriginalDocumentLeft ? "Ofisda" : "O'zida",
                                      style: TextStyle(
                                        color: isAtOffice ? Colors.blue : Colors.orange,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Switch orqali o'zgartirish
                                    Transform.scale(
                                      scale: 0.8, // Switch biroz kichikroq bo'lishi uchun
                                      child: Switch(
                                        value: isAtOffice,
                                        activeColor: Colors.blue,
                                        activeTrackColor: Colors.blue.withOpacity(0.3),
                                        inactiveThumbColor: Colors.orange,
                                        inactiveTrackColor: Colors.orange.withOpacity(0.3),
                                        onChanged: (bool value) {
                                          setState(() {
                                            index.isOriginalDocumentLeft=value;
                                          });
                                          print("Passport holati o'zgardi: $value");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                                    onPressed: () {},
                                    tooltip: "Tahrirlash",
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    onPressed: () {},
                                    tooltip: "O'chirish",
                                  ),
                                ],
                              )),
                            ]);
                          }
                      ).toList(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 2-Rasm: Mijozlar jadvali
  // Widget _buildCustomerTable() {
  //   return ;
  // }

  // Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
  //       SizedBox(height: 8),
  //       TextField(
  //         maxLines: maxLines,
  //         decoration: InputDecoration(
  //           hintText: hint,
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //           filled: true,
  //           fillColor: Colors.grey[50],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}