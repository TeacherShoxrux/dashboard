import 'package:flutter/material.dart';

class ReturnProductDialog extends StatefulWidget {
  final String customerName;
  final List<Map<String, dynamic>> rentedItems; // Ijaradagi mahsulotlar ro'yxati

  const ReturnProductDialog({
    Key? key,
    required this.customerName,
    required this.rentedItems
  }) : super(key: key);

  @override
  _ReturnProductDialogState createState() => _ReturnProductDialogState();
}

class _ReturnProductDialogState extends State<ReturnProductDialog> {
  // Qaytarilayotgan mahsulotlar va ularning sonini saqlash uchun
  Map<int, bool> selectedItems = {};
  Map<int, int> returnQuantities = {};
  double additionalPayment = 0.0;
  String comment = "";

  @override
  void initState() {
    super.initState();
    // Boshlang'ich holatda barcha mahsulotlar va ularning to'liq sonini o'rnatamiz
    for (int i = 0; i < widget.rentedItems.length; i++) {
      selectedItems[i] = true;
      returnQuantities[i] = widget.rentedItems[i]['qty'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mahsulotlarni qaytarib olish", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Mijoz: ${widget.customerName}", style: const TextStyle(fontSize: 14, color: Colors.blue)),
        ],
      ),
      content: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. MAHSULOTLAR RO'YXATI
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.rentedItems.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    var item = widget.rentedItems[index];
                    bool isSelected = selectedItems[index] ?? false;

                    return ListTile(
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (val) => setState(() => selectedItems[index] = val!),
                      ),
                      title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text("Jami ijarada: ${item['qty']} ta"),
                      trailing: isSelected
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            onPressed: () {
                              if (returnQuantities[index]! > 1) {
                                setState(() => returnQuantities[index] = returnQuantities[index]! - 1);
                              }
                            },
                          ),
                          Text("${returnQuantities[index]}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                            onPressed: () {
                              if (returnQuantities[index]! < item['qty']) {
                                setState(() => returnQuantities[index] = returnQuantities[index]! + 1);
                              }
                            },
                          ),
                        ],
                      )
                          : const Text("Qaytarilmaydi", style: TextStyle(color: Colors.grey)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),

              // 2. TO'LOV VA IZOHLAR
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (val) => additionalPayment = double.tryParse(val) ?? 0.0,
                      decoration: InputDecoration(
                        labelText: "Qabul qilingan to'lov (so'm)",
                        hintText: "Masalan: jarima yoki qoldiq to'lov",
                        prefixIcon: const Icon(Icons.payments, color: Colors.green),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
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
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextField(
                maxLines: 2,
                onChanged: (val) => comment = val,
                decoration: InputDecoration(
                  labelText: "Izoh (Zararlar yoki eslatmalar)",
                  hintText: "Masalan: obyektivda qirilgan joyi bor...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Bekor qilish")),
        ElevatedButton(
          onPressed: () {
            // Tanlangan mahsulotlarni va ularning sonini backendga yuborish logikasi
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          ),
          child: const Text("Qabul qilish"),
        ),
      ],
    );
  }
}