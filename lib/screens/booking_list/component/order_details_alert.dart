import 'package:flutter/material.dart';

class OrderDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> orderData; // Buyurtma ma'lumotlari backenddan keladi

  const OrderDetailsDialog({Key? key, required this.orderData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Buyurtma #${orderData['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
          _buildStatusBadge(orderData['status']),
        ],
      ),
      content: SizedBox(
        width: 650,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. MIJOZ VA VAQT MA'LUMOTLARI
              _buildInfoSection(context),
              const Divider(height: 40),

              // 2. MAHSULOTLAR RO'YXATI (HAMMASI)
              const Text("Mahsulotlar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildProductsList(),
              const Divider(height: 40),

              // 3. TO'LOV HISOB-KITOBI
              _buildPaymentSummary(),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Yopish"),
        ),
        ElevatedButton.icon(
          onPressed: () { /* Chekni chiqarish */ },
          icon: const Icon(Icons.print),
          label: const Text("Chek chiqarish"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
        ),
      ],
    );
  }

  // Mijoz va Vaqt bo'limi
  Widget _buildInfoSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoTile(Icons.person, "Mijoz", orderData['customer_name']),
        _infoTile(Icons.phone, "Telefon", orderData['customer_phone']),
        _infoTile(Icons.calendar_today, "Muddat", "${orderData['start_date']} — ${orderData['end_date']}"),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Mahsulotlar ro'yxati
  Widget _buildProductsList() {
    List products = orderData['products'] ?? [];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          var p = products[index];
          return ListTile(
            leading: CircleAvatar(backgroundColor: Colors.blue[100], child: Text("${index + 1}", style: const TextStyle(fontSize: 12))),
            title: Text(p['name']),
            subtitle: Text("${p['price']} so'm x ${p['qty']} ta"),
            trailing: Text("${p['price'] * p['qty']} so'm", style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }

  // To'lov xulosasi
  Widget _buildPaymentSummary() {
    double total = orderData['total_amount'] ?? 0.0;
    double paid = orderData['paid_amount'] ?? 0.0;
    double debt = total - paid;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _summaryRow("Umumiy summa:", "$total so'm", Colors.white),
          const SizedBox(height: 8),
          _summaryRow("To'langan:", "$paid so'm", Colors.greenAccent),
          const Divider(color: Colors.white24, height: 20),
          _summaryRow("Qolgan to'lov:", "$debt so'm", debt > 0 ? Colors.orangeAccent : Colors.greenAccent, isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(color: color, fontSize: isBold ? 18 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == "Ijarada" ? Colors.blue : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}