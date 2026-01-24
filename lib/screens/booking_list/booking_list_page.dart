import 'package:admin/screens/booking_list/customer_search.dart';
import 'package:flutter/material.dart';

import '../main_layout/date_range_picker.dart';
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomerSearchWidget(),
            ),
            SpaceDateRangePicker()
          ],
        ),
      ),
    );
  }
  //
  // DataRow _buildBookingRow(int index) {
  //   return DataRow(cells: [
  //     // Mijoz
  //     DataCell(Text("Javohir Kudratov",
  //         style: TextStyle(fontWeight: FontWeight.w600))),
  //
  //     // Band qilingan narsalar (Bir nechta bo'lishi mumkin)
  //     DataCell(Tooltip(
  //       message: "Sony A7III, 24-70mm Lens",
  //       child: TextButton(
  //           onPressed: () {
  //             showDialog(
  //               context: context,
  //               builder: (context) => OrderDetailsDialog(
  //                 orderData: {
  //                   "id": "1045",
  //                   "status": "Ijarada",
  //                   "customer_name": "Ali Valiyev",
  //                   "customer_phone": "+998 90 123 45 67",
  //                   "start_date": "12.01.2026",
  //                   "end_date": "20.01.2026",
  //                   "total_amount": 2500000.0,
  //                   "paid_amount": 1000000.0,
  //                   "products": [
  //                     {"name": "Sony A7III", "qty": 1, "price": 1500000},
  //                     {"name": "24-70mm Lens", "qty": 1, "price": 800000},
  //                     {"name": "Tripod Stand", "qty": 1, "price": 200000},
  //                   ]
  //                 },
  //               ),
  //             );
  //           },
  //           child:
  //               Text("Sony A7III +1...", style: TextStyle(color: Colors.blue))),
  //     )),
  //
  //     // Qachon band qilingan
  //     DataCell(Text("16.01.2026")),
  //
  //     // Qaysi oraliqqa
  //     DataCell(Text("18.01 - 22.01")),
  //
  //     // Holati
  //     DataCell(
  //       Chip(
  //         label: Text(index % 2 == 0 ? "Tasdiqlangan" : "Kutilmoqda"),
  //         backgroundColor: index % 2 == 0 ? Colors.blue[50] : Colors.orange[50],
  //         labelStyle: TextStyle(
  //           color: index % 2 == 0 ? Colors.blue[700] : Colors.orange[800],
  //           fontSize: 12,
  //           fontWeight: FontWeight.bold,
  //         ),
  //         side: BorderSide.none,
  //       ),
  //     ),
  //
  //     // Amallar
  //     DataCell(
  //       Row(
  //         children: [
  //           // Ijaraga berish (Bronni real ijaraga aylantirish)
  //           IconButton(
  //             icon: const Icon(Icons.play_arrow_rounded, color: Colors.green),
  //             onPressed: () {
  //               showDialog(
  //                 context: context,
  //                 barrierDismissible:
  //                     false, // Foydalanuvchi chetni bossa yopilib ketmasligi uchun
  //                 builder: (context) => StartRentalFromBookingDialog(
  //                   customerName: "Rustam Axmerov",
  //                   bookedItems: [
  //                     {"name": "Sony A7III", "qty": 10},
  //                     {"name": "Tripod Stand", "qty": 5},
  //                     {"name": "Sony A7III", "qty": 10},
  //                     {"name": "Tripod Stand", "qty": 5},
  //                     {"name": "Sony A7III", "qty": 10},
  //                     {"name": "Sony A7III", "qty": 10},
  //                     {"name": "Tripod Stand", "qty": 5},
  //                     {"name": "Sony A7III", "qty": 10},
  //                     {"name": "Sony A7III", "qty": 10},
  //                     {"name": "Tripod Stand", "qty": 5},
  //                     {"name": "Sony A7III", "qty": 10},
  //                   ],
  //                 ),
  //               );
  //             },
  //             tooltip: "Ijarani boshlash",
  //           ),
  //           // Bekor qilish
  //           IconButton(
  //             icon: const Icon(Icons.cancel_outlined, color: Colors.red),
  //             onPressed: () {},
  //             tooltip: "Bekor qilish",
  //           ),
  //         ],
  //       ),
  //     ),
  //   ]);
  // }
}
