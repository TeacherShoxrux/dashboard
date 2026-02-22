import 'package:admin/network/api_constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String subName;
  final String price;
  final String? img;


  const ProductCard({
    Key? key,
    required this.name,
    required this.subName,
    required this.price, this.img,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0; // Savatdagi miqdor

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage("${ApiConstants.baseUrl}${widget.img}"),fit: BoxFit.cover),
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  // child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. NOMI VA SUB-NOMI
                    Text(
                      widget.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.subName,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${widget.price} so'm",
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // 3. SAVATGA QO'SHISH YOKI +- BUTTONLAR
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: quantity == 0
                          ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => setState(() => quantity = 1),
                          child: const Text("Savatga", style: TextStyle(color: Colors.white)),
                        ),
                      )
                          : Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.blue),
                              onPressed: () => setState(() => quantity--),
                            ),
                            Text(
                              "$quantity",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.blue),
                              onPressed: () => setState(() => quantity++),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Asosiy jadvalingizdagi tugma
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              tooltip: "Buzilgan deb belgilash",
              onPressed: () => _showReportDamageDialog(context, {'name': widget.name}),
            ),
          ),
        ],
      ),
    );
  }
  void _showReportDamageDialog(BuildContext context, Map<String, dynamic> item) {
    String selectedSeverity = "O'rta";
    final TextEditingController reasonController = TextEditingController();
    final TextEditingController estimateCostController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Dropdown o'zgarishi dialog ichida ko'rinishi uchun
            builder: (context, setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                title: const Row(
                  children: [
                    Icon(Icons.report_problem, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Buzilishni qayd etish"),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${item['name']} mahsulotiga zarar yetganini tasdiqlaysizmi?",
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),

                      // Buzilish darajasi
                      DropdownButtonFormField<String>(
                        value: selectedSeverity,
                        decoration: InputDecoration(
                          labelText: "Buzilish darajasi",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: ["Yengil", "O'rta", "Og'ir"].map((s) =>
                            DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (val) {
                          setDialogState(() => selectedSeverity = val!);
                        },
                      ),
                      const SizedBox(height: 15),

                      // Sababi
                      TextField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Buzilish sababi / Izoh",
                          hintText: "Masalan: Mijoz tomonidan tushirib yuborilgan...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Taxminiy xarajat
                      TextField(
                        controller: estimateCostController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Taxminiy zarar summasi",
                          prefixText: "UZS ",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Bekor qilish"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: () {
                      // BACKENDGA YUBORISH (POST /api/damaged-items)
                      // item['id'] orqali mahsulot statusini 'Damaged'ga o'zgartirasiz

                      print("Mahsulot buzilgan deb qayd etildi: ${item['name']}");
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${item['name']} nosoz mahsulotlar ro'yxatiga o'tkazildi"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                    child: const Text("Buzilgan deb belgilansin"),
                  ),
                ],
              );
            }
        );
      },
    );
  }
}