import 'package:flutter/material.dart';

import 'component/booking_to_rent_alert.dart';
import 'component/order_details_alert.dart';

class BookingListPage extends StatefulWidget {
  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = "Barchasi";

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
              "Band qilingan mahsulotlar (Booking)",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 1. QIDIRUV VA FILTRLAR
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Mijoz ismi yoki bron raqami...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      // fillColor: Colors.grey[50],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: selectedFilter,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: [
                      "Barchasi",
                      "Kutilmoqda",
                      "Tasdiqlangan",
                      "Bekor qilingan"
                    ]
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedFilter = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. BAND QILINGANLAR JADVALI
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
                      DataColumn(label: Text('Mahsulotlar')),
                      DataColumn(label: Text('Bron Sanasi')),
                      DataColumn(label: Text('Muddati')),
                      DataColumn(label: Text('Holati')),
                      DataColumn(label: Text('Amallar')),
                    ],
                    rows: List.generate(38, (index) => _buildBookingRow(index)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildBookingRow(int index) {
    return DataRow(cells: [
      // Mijoz
      DataCell(Text("Javohir Kudratov",
          style: TextStyle(fontWeight: FontWeight.w600))),

      // Band qilingan narsalar (Bir nechta bo'lishi mumkin)
      DataCell(Tooltip(
        message: "Sony A7III, 24-70mm Lens",
        child: TextButton(
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
                    ]
                  },
                ),
              );
            },
            child:
                Text("Sony A7III +1...", style: TextStyle(color: Colors.blue))),
      )),

      // Qachon band qilingan
      DataCell(Text("16.01.2026")),

      // Qaysi oraliqqa
      DataCell(Text("18.01 - 22.01")),

      // Holati
      DataCell(
        Chip(
          label: Text(index % 2 == 0 ? "Tasdiqlangan" : "Kutilmoqda"),
          backgroundColor: index % 2 == 0 ? Colors.blue[50] : Colors.orange[50],
          labelStyle: TextStyle(
            color: index % 2 == 0 ? Colors.blue[700] : Colors.orange[800],
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          side: BorderSide.none,
        ),
      ),

      // Amallar
      DataCell(
        Row(
          children: [
            // Ijaraga berish (Bronni real ijaraga aylantirish)
            IconButton(
              icon: const Icon(Icons.play_arrow_rounded, color: Colors.green),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Foydalanuvchi chetni bossa yopilib ketmasligi uchun
                  builder: (context) => StartRentalFromBookingDialog(
                    customerName: "Rustam Axmerov",
                    bookedItems: [
                      {"name": "Sony A7III", "qty": 10},
                      {"name": "Tripod Stand", "qty": 5},
                      {"name": "Sony A7III", "qty": 10},
                      {"name": "Tripod Stand", "qty": 5},
                      {"name": "Sony A7III", "qty": 10},
                      {"name": "Sony A7III", "qty": 10},
                      {"name": "Tripod Stand", "qty": 5},
                      {"name": "Sony A7III", "qty": 10},
                      {"name": "Sony A7III", "qty": 10},
                      {"name": "Tripod Stand", "qty": 5},
                      {"name": "Sony A7III", "qty": 10},
                    ],
                  ),
                );
              },
              tooltip: "Ijarani boshlash",
            ),
            // Bekor qilish
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              onPressed: () {},
              tooltip: "Bekor qilish",
            ),
          ],
        ),
      ),
    ]);
  }
}
