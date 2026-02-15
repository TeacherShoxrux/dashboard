import 'package:flutter/material.dart';

import 'components/booking_appbar.dart';

// 1. Ma'lumotlar modeli
class BookingModel {
  final String id;
  final String name;
  final String phone;
  final String bookingDate;
  final String startDate;
  final String status;

  BookingModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.bookingDate,
    required this.startDate,
    required this.status,
  });
}

// 2. Jadval uchun ma'lumotlar manbasi (DataSource)
class BookingDataSource extends DataTableSource {
  final List<BookingModel> _bookings;
  final BuildContext context;

  BookingDataSource(this._bookings, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= _bookings.length) return null;
    final booking = _bookings[index];

    return DataRow(cells: [
      DataCell(Text(booking.id, style: const TextStyle(color: Colors.white70))),
      DataCell(Icon(Icons.person, color: Color(0xFF40E0D0))),
      DataCell(Text(booking.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      DataCell(Text(booking.phone, style: const TextStyle(color: Colors.white70))),
      DataCell(Text(booking.bookingDate, style: const TextStyle(color: Colors.white70))),
      DataCell(Text(booking.startDate, style: const TextStyle(color: Colors.white70))),
      DataCell(_buildStatusChip(booking.status)),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.play_circle_fill, color: Colors.green), onPressed: () {}),
          IconButton(icon: const Icon(Icons.cancel, color: Colors.redAccent), onPressed: () {}),
        ],
      )),
    ]);
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case "Tasdiqlangan": color = Colors.green; break;
      case "Kutilmoqda": color = Colors.orange; break;
      case "Bekor qilingan": color = Colors.red; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _bookings.length;

  @override
  int get selectedRowCount => 0;
}

// 3. Asosiy sahifa
class RentedListPage extends StatefulWidget {
  const RentedListPage({super.key});

  @override
  State<RentedListPage> createState() => _ResponsiveBookingPageState();
}

class _ResponsiveBookingPageState extends State<RentedListPage> {
  // Namuna uchun ma'lumotlar
  final List<BookingModel> _data = List.generate(50, (index) => BookingModel(
    id: "#${1000 + index}",
    name: "Javohir Qudratov",
    phone: "+998 90 123 45 67",
    bookingDate: "24.01.2026",
    startDate: "10:00 - 20:00",
    status: index % 3 == 0 ? "Tasdiqlangan" : (index % 3 == 1 ? "Kutilmoqda" : "Bekor qilingan"),
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1221),
      appBar: BookingAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Theme(
          // Jadvalni to'q rangga moslash
          data: Theme.of(context).copyWith(
            cardColor: const Color(0xFF161A33),
            dividerColor: Colors.white10,
            textTheme: const TextTheme(bodySmall: TextStyle(color: Colors.white)),
          ),
          child: PaginatedDataTable(
            header: const Text("Mijozlar bandlovi", style: TextStyle(color: Colors.white)),
            rowsPerPage: 10,
            columnSpacing: 20,
            horizontalMargin: 15,
            showFirstLastButtons: true,
            arrowHeadColor: const Color(0xFF40E0D0),
            columns: const [
              DataColumn(label: Text("ID", style: TextStyle(color: Color(0xFF40E0D0)))),
              DataColumn(label: Text("Rasmi", style: TextStyle(color: Color(0xFF40E0D0)))),
              DataColumn(label: Text("Ism Familya", style: TextStyle(color: Color(0xFF40E0D0)))),
              DataColumn(label: Text("Tel raqam", style: TextStyle(color: Color(0xFF40E0D0)))),
              DataColumn(label: Text("Bron sanasi", style: TextStyle(color: Color(0xFF40E0D0)))),
              DataColumn(label: Text("Boshlash", style: TextStyle(color: Color(0xFF40E0D0)))),
              DataColumn(label: Text("Holati", style: TextStyle(color: Color(0xFF40E0D0)))),
              DataColumn(label: Text("Amallar", style: TextStyle(color: Color(0xFF40E0D0)))),
            ],
            source: BookingDataSource(_data, context),
          ),
        ),
      ),
    );
  }
}