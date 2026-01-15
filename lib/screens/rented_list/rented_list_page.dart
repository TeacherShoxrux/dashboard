import 'package:flutter/material.dart';

import '../booking_list/component/order_details_alert.dart';
import '../product_selection/components/add_product_alert.dart';
import 'components/return_product_dialog.dart';

class RentedListPage extends StatefulWidget {
  @override
  _RentedListPageState createState() => _RentedListPageState();
}

class _RentedListPageState extends State<RentedListPage> {
  final TextEditingController _searchController = TextEditingController();
  String selectedStatus = "Hammasi";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ijaradagi mahsulotlar ro'yxati",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 1. QIDIRUV VA FILTR QISMI
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Mijoz yoki mahsulot bo'yicha qidirish...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      // fillColor: Colors.grey[50],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    // dropdownColor: Colors.transparent,
                    value: selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: ["Hammasi", "Ijarada", "Muddati o'tgan", "Qaytarilgan"]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedStatus = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. IJARADAGILAR JADVALI
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: DataTable(
                    // headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                    columns: const [
                      DataColumn(label: Text('Mijoz')),
                      DataColumn(label: Text('Mahsulot')),
                      DataColumn(label: Text('Olingan sana')),
                      DataColumn(label: Text('Qaytish sanasi')),
                      DataColumn(label: Text('Holati')),
                      DataColumn(label: Text('Amallar')),
                    ],
                    rows: List.generate(110, (index) => _buildRentRow(index)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildRentRow(int index) {
    return DataRow(cells: [
      // Mijoz ma'lumotlari
      DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Ali Valiyev", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("+998 90 123 45 67", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
      // Mahsulot ma'lumotlari
      DataCell(
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => OrderDetailsDialog(
                orderData: {
                  "id": "1045",
                  "status": "Ijarada",
                  "customer_name": "Ali Valiyev",
                  "customer_phone": "+998 90 123 45 67",
                  "start_date": "12.01.2026",
                  "end_date": "20.01.2026",
                  "total_amount": 2500000.0,
                  "paid_amount": 1000000.0,
                  "products": [
                    {"name": "Sony A7III", "qty": 1, "price": 1500000},
                    {"name": "24-70mm Lens", "qty": 1, "price": 800000},
                    {"name": "Tripod Stand", "qty": 1, "price": 200000},
                    {"name": "Sony A7III", "qty": 1, "price": 1500000},
                    {"name": "24-70mm Lens", "qty": 1, "price": 800000},
                    {"name": "Tripod Stand", "qty": 1, "price": 200000},
                    {"name": "Sony A7III", "qty": 1, "price": 1500000},
                    {"name": "24-70mm Lens", "qty": 1, "price": 800000},
                    {"name": "Tripod Stand", "qty": 1, "price": 200000},
                    {"name": "Sony A7III", "qty": 1, "price": 1500000},
                    {"name": "24-70mm Lens", "qty": 1, "price": 800000},
                    {"name": "Tripod Stand", "qty": 1, "price": 200000},
                  ]
                },
              ),
            );
          },
          child: Row(
            children: [
              const Icon(Icons.laptop, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              const Text("MacBook Pro M3"),
            ],
          ),
        ),
      ),
      DataCell(const Text("12.01.2024")),
      DataCell(const Text("20.01.2024")),
      // Holati (Badge)
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: index % 3 == 0 ? Colors.red[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            index % 3 == 0 ? "Muddati o'tgan" : "Ijarada",
            style: TextStyle(
              color: index % 3 == 0 ? Colors.red : Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      // Amallar
      DataCell(
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.assignment_return, color: Colors.green),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ReturnProductDialog(
                    customerName: "Ali Valiyev",
                    rentedItems: [
                      {"name": "Sony A7III", "qty": 2},
                      {"name": "24-70mm Lens", "qty": 1},
                    ],
                  ),
                );
              }, // Qaytarib olish funksiyasi
              tooltip: "Qaytarib olish",
            ),
            IconButton(
              icon: const Icon(Icons.print, color: Colors.grey),
              onPressed: () {}, // Shartnomani chop etish
              tooltip: "Chek chiqarish",
            ),
          ],
        ),
      ),
    ]);
  }
}