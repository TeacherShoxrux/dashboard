import 'package:flutter/material.dart';

class DamagedItemsPage extends StatefulWidget {
  const DamagedItemsPage({super.key});

  @override
  State<DamagedItemsPage> createState() => _DamagedItemsPageState();
}

class _DamagedItemsPageState extends State<DamagedItemsPage> {
  String searchQuery = "";
  String selectedFilter = "Barchasi";

  // Namuna sifatida buzilgan mahsulotlar ro'yxati
  final List<Map<String, dynamic>> damagedItems = [
    {
      "id": "1024",
      "name": "Sony PlayStation 5",
      "client": "Ali Valiyev",
      "date": "2026-01-15",
      "reason": "Joystik tugmachasi ishlamay qolgan (qattiq bosilgan)",
      "severity": "Yengil", // Yengil, O'rta, Og'ir
      "repairCost": "150,000 so'm",
      "status": "Ta'mirda"
    },
    {
      "id": "1055",
      "name": "Canon EOS R6 Kamera",
      "client": "Sardor Rahimov",
      "date": "2026-01-10",
      "reason": "Ob'ektiv oynasi chizilgan (qulab tushgan)",
      "severity": "Og'ir",
      "repairCost": "2,400,000 so'm",
      "status": "Kutilmoqda"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nosoz va buzilgan mahsulotlar",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 1. QIDIRUV VA FILTR QISMI
            _buildSearchAndFilter(),

            const SizedBox(height: 20),

            // 2. MAHSULOTLAR JADVALI
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 40,
                      headingRowColor: WidgetStateProperty.all(Colors.white10),
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Mahsulot nomi')),
                        DataColumn(label: Text('Mijoz')),
                        DataColumn(label: Text('Sana')),
                        DataColumn(label: Text('Buzilish sababi')),
                        DataColumn(label: Text('Darajasi')),
                        DataColumn(label: Text('Taxminiy zarar')),
                        DataColumn(label: Text('Holati')),
                        DataColumn(label: Text('Amallar')),
                      ],
                      rows: damagedItems.map((item) => _buildDataRow(item)).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Qidiruv va Filtr vidjeti
  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Mahsulot yoki mijoz bo'yicha qidirish...",
              prefixIcon: const Icon(Icons.search),
              // fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: (val) => setState(() => searchQuery = val),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<String>(
            value: selectedFilter,
            decoration: InputDecoration(
              filled: true,
              // fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: ["Barchasi", "Yengil", "O'rta", "Og'ir"].map((f) {
              return DropdownMenuItem(value: f, child: Text(f));
            }).toList(),
            onChanged: (val) => setState(() => selectedFilter = val!),
          ),
        ),
      ],
    );
  }

  // Jadval qatori
  DataRow _buildDataRow(Map<String, dynamic> item) {
    Color severityColor = item['severity'] == "Og'ir" ? Colors.red : Colors.orange;

    return DataRow(cells: [
      DataCell(Text(item['id'])),
      DataCell(Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(item['client'])),
      DataCell(Text(item['date'])),
      DataCell(
        SizedBox(
          width: 250,
          child: Text(item['reason'], overflow: TextOverflow.ellipsis, maxLines: 2),
        ),
      ),
      DataCell(
        Chip(
          label: Text(item['severity'], style: const TextStyle(color: Colors.white, fontSize: 11)),
          backgroundColor: severityColor,
          padding: EdgeInsets.zero,
        ),
      ),
      DataCell(Text(item['repairCost'], style: const TextStyle(color: Colors.red))),
      DataCell(Text(item['status'])),
      DataCell(
        Row(
          children: [
            IconButton(icon: const Icon(Icons.visibility, color: Colors.blue), onPressed: () {
              // _showReportDamageDialog(context, item);
            }),
            IconButton(icon: const Icon(Icons.build, color: Colors.green), onPressed: () {
              _showRepairCompleteDialog(context, item);
            }),
          ],
        ),
      ),
    ]);
  }
  void _showRepairCompleteDialog(BuildContext context, Map<String, dynamic> item) {
    final TextEditingController costController = TextEditingController(text: item['repairCost'].replaceAll(RegExp(r'[^0-9]'), ''));
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green),
              const SizedBox(width: 10),
              Text("${item['name']} - Ta'mirni yakunlash"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Mahsulot to'liq sozlandimi? Ma'lumotlarni tasdiqlang:"),
              const SizedBox(height: 20),

              // Haqiqiy ta'mirlash xarajati
              TextField(
                controller: costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Yakuniy ta'mirlash xarajati (so'm)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.money),
                ),
              ),
              const SizedBox(height: 15),

              // Usta yoki admin izohi
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Ta'mirlash haqida izoh",
                  hintText: "Masalan: Ekran almashtirildi, texnik ko'rikdan o'tdi.",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Bekor qilish", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                // BU YERDA BACKEND (ASP.NET Core) BILAN BOG'LANISH:
                // 1. Mahsulot statusini 'Available' ga o'zgartirish
                // 2. Ta'mirlash tarixiga xarajat va izohni saqlash

                print("Mahsulot aktiv holatga qaytarildi: ${item['name']}");
                print("Xarajat: ${costController.text}");

                Navigator.pop(context);

                // Muvaffaqiyatli yakunlangani haqida xabar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${item['name']} yana ijaraga berishga tayyor!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Sozlandi va Aktivga qaytarilsin"),
            ),
          ],
        );
      },
    );
  }



}