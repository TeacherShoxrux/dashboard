import 'package:flutter/material.dart';

import 'customer_selector.dart';

class RentalCheckoutDialog extends StatefulWidget {
  @override
  _RentalCheckoutDialogState createState() => _RentalCheckoutDialogState();
}
enum DocumentType {
  driverLicense,
  passportPlusZagran,
  idCard,
  none
}
class _RentalCheckoutDialogState extends State<RentalCheckoutDialog> {
  DocumentType _selectedDoc = DocumentType.none;
  String paymentMethod = "Naqd";
  bool isBooking = false;
  DateTimeRange? selectedRange;
  double paidAmount = 0.0;

  // Test uchun mijozlar ro'yxati
  final List<Map<String, String>> allCustomers = [
    {'name': 'Ali Valiev', 'phone': '+998901234567'},
    {'name': 'Olim Toshov', 'phone': '+998939876543'},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 500, // Web va planshet uchun qulay kenglik
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rasmiylashtirish", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Divider(height: 20),

            CustomerSelector(),

            const SizedBox(height: 20),

            // --- HUJJATNI OLIB QOLISH (Yangi qism) ---
            Text("Hujjatni olib qolish:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  RadioListTile<DocumentType>(
                    title: Text("Haydovchilik guvohnomasi"),
                    value: DocumentType.driverLicense,
                    groupValue: _selectedDoc,
                    onChanged: (v) => setState(() => _selectedDoc = v!),
                  ),
                  RadioListTile<DocumentType>(
                    title: Text("Passport + Zagran passport"),
                    value: DocumentType.passportPlusZagran,
                    groupValue: _selectedDoc,
                    onChanged: (v) => setState(() => _selectedDoc = v!),
                  ),
                  RadioListTile<DocumentType>(
                    title: Text("ID Card"),
                    value: DocumentType.idCard,
                    groupValue: _selectedDoc,
                    onChanged: (v) => setState(() => _selectedDoc = v!),
                  ),
                  RadioListTile<DocumentType>(
                    title: Text("Hujjat olinmadi"),
                    value: DocumentType.none,
                    groupValue: _selectedDoc,
                    onChanged: (v) => setState(() => _selectedDoc = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- IJARA TURI ---
            Text("Turi:", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                ChoiceChip(
                  label: Text("Rent"),
                  selected: !isBooking,
                  onSelected: (v) => setState(() => isBooking = false),
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text("Booking"),
                  selected: isBooking,
                  onSelected: (v) => setState(() => isBooking = true),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- SANANI TANLASH ---
            const SizedBox(height: 20),

            // Sanani tanlash
            Text("Ijara muddati:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  // RESPONSIVE BUILDER QISMI
                  builder: (context, child) {
                    return Center(
                      child: Container(
                        // Webda oyna o'lchamini cheklaymiz
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
                          maxHeight: MediaQuery.of(context).size.width > 600 ? 600 : double.infinity,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: child,
                        ),
                      ),
                    );
                  },
                );
                if (range != null) setState(() => selectedRange = range);
              },
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(selectedRange == null
                  ? "Kunlarni tanlang"
                  : "${selectedRange!.start.toString().split(' ')[0]} - ${selectedRange!.end.toString().split(' ')[0]}"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),


            const SizedBox(height: 20),


            Text("To'lov turi va summa:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // 1. TO'LOV TURI DROPDOWN
                  DropdownButtonFormField<String>(
                    value: paymentMethod,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.payments_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      // fillColor: Colors.white,
                    ),
                    items: ["Naqd", "Karta (UzCard/Humo)", "Click/Payme", "Terminal"]
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) => setState(() => paymentMethod = v!),
                  ),

                  const SizedBox(height: 15),

                  // 2. TO'LANGAN SUMMANI KIRITISH MAYDONI
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        paidAmount = double.tryParse(value) ?? 0.0;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "To'langan summa",
                      hintText: "0.00",
                      prefixIcon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.green),
                      suffixText: "so'm",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      // fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- TASDIQLASH ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: isBooking ? Colors.orange : Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: () {
                  // Baza bilan bog'lash: _selectedDoc, isBooking, selectedRange va barcha ma'lumotlarni yuboring
                  Navigator.pop(context);
                },
                child: Text(isBooking ? "BAND QILISH" : "IJARANI BOSHLASH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}