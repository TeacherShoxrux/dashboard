import 'package:flutter/material.dart';

class StartRentalFromBookingDialog extends StatefulWidget {
  final String customerName;
  final List<Map<String, dynamic>> bookedItems; // Band qilingan narsalar

  const StartRentalFromBookingDialog({
    Key? key,
    required this.customerName,
    required this.bookedItems,
  }) : super(key: key);

  @override
  _StartRentalFromBookingDialogState createState() => _StartRentalFromBookingDialogState();
}

class _StartRentalFromBookingDialogState extends State<StartRentalFromBookingDialog> {
  // Tanlangan mahsulotlar va ularning yakuniy ijaraga olinadigan soni
  Map<int, bool> willRent = {};
  Map<int, int> finalQuantities = {};
  double advancePayment = 0.0;

  @override
  void initState() {
    super.initState();
    // Boshlang'ich holatda barcha booking qilingan narsalarni tanlangan deb hisoblaymiz
    for (int i = 0; i < widget.bookedItems.length; i++) {
      willRent[i] = true;
      finalQuantities[i] = widget.bookedItems[i]['qty'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Bookingni ijaraga aylantirish", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Mijoz: ${widget.customerName}", style: const TextStyle(fontSize: 14, color: Colors.orange)),
        ],
      ),
      content: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Hozir olinayotgan mahsulotlarni belgilang:",
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ),
              const SizedBox(height: 10),

              // 1. BOOKING QILINGAN MAHSULOTLAR RO'YXATI
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.bookedItems.length,
                  itemBuilder: (context, index) {
                    var item = widget.bookedItems[index];
                    bool isSelected = willRent[index] ?? false;

                    return Container(
                      color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.transparent,
                      child: ListTile(
                        leading: Checkbox(
                          activeColor: Colors.blue,
                          value: isSelected,
                          onChanged: (val) => setState(() => willRent[index] = val!),
                        ),
                        title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text("Band qilingan: ${item['qty']} ta"),
                        trailing: isSelected
                            ? _buildQuantityPicker(index, item['qty'])
                            : const Text("Olinmaydi", style: TextStyle(color: Colors.red, fontSize: 12)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),

              // 2. TO'LOV VA QO'SHIMCHA MA'LUMOTLAR
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Hozirgi to'lov (Avans)",
                        prefixIcon: const Icon(Icons.payments, color: Colors.green),
                        suffixText: "so'm",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (val) => advancePayment = double.tryParse(val) ?? 0.0,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "To'lov turi",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ["Naqd", "Karta", "Click"]
                          .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Bekor qilish")),
        ElevatedButton(
          onPressed: () {
            // Faqat willRent[index] == true bo'lganlarni va finalQuantities[index] ni bazaga yuborish
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Ijarani boshlash"),
        ),
      ],
    );
  }

  // Miqdorni o'zgartirish vidjeti
  Widget _buildQuantityPicker(int index, int maxQty) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
          onPressed: () {
            if (finalQuantities[index]! > 1) {
              setState(() => finalQuantities[index] = finalQuantities[index]! - 1);
            }
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
          child: Text("${finalQuantities[index]}", style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
          onPressed: () {
            if (finalQuantities[index]! < maxQty) {
              setState(() => finalQuantities[index] = finalQuantities[index]! + 1);
            }
          },
        ),
      ],
    );
  }
}