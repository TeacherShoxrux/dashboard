import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. XUSH KELIBSIZ VA BUGUNGI SANA
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Xush kelibsiz, Admin 👋",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    Text("Bugun: 16-Yanvar, 2026",
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
                Icon(Icons.notifications_none, size: 30, color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 30),

            // 2. TEZKOR STATISTIKA (KPI Cards)
            _buildQuickStats(),

            const SizedBox(height: 30),

            // 3. ASOSIY KONTENT: Grafika va Oxirgi harakatlar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chap tomonda asosiy grafik
                Expanded(flex: 2, child: _buildMainChart()),
                const SizedBox(width: 24),
                // O'ng tomonda statuslar bo'yicha qisqacha ma'lumot
                Expanded(flex: 1, child: _buildStatusSummary()),
              ],
            ),

            const SizedBox(height: 30),

            // 4. OXIRGI IJARALAR VA BAND QILISHLAR (Table)
            _buildRecentActivitiesTable(),
          ],
        ),
      ),
    );
  }

  // Tezkor ko'rsatkichlar kartalari
  Widget _buildQuickStats() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _statCard("Faol ijaralar", "42 ta", Icons.swap_horizontal_circle, Colors.blue),
        _statCard("Bugungi tushum", "1,250,000 so'm", Icons.account_balance_wallet, Colors.green),
        _statCard("Band qilinganlar", "15 ta", Icons.event_available, Colors.orange),
        _statCard("Qarzdorlar", "8 ta", Icons.assignment_late, Colors.red),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 250, // Webda barqaror kenglik, Mobileda Wrap pastga tushiradi
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // Grafik o'rni
  Widget _buildMainChart() {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.3), borderRadius: BorderRadius.circular(16)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Haftalik ijara dinamikasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Spacer(),
          Center(child: Text("Haftalik grafik (fl_chart) bu yerda bo'ladi", style: TextStyle(color: Colors.grey))),
          Spacer(),
        ],
      ),
    );
  }

  // Statuslar bo'yicha qisqacha ma'lumot
  Widget _buildStatusSummary() {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.25), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mahsulotlar holati", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _statusItem("Do'konda", 120, Colors.green),
          _statusItem("Ijarada", 42, Colors.blue),
          _statusItem("Servisda", 5, Colors.orange),
          _statusItem("Yo'qolgan", 2, Colors.red),
        ],
      ),
    );
  }

  Widget _statusItem(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Text(label),
            ],
          ),
          Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Oxirgi harakatlar jadvali
  Widget _buildRecentActivitiesTable() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.35), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Oxirgi ijara harakatlari", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              const TableRow(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Text("Mijoz", style: TextStyle(fontWeight: FontWeight.bold))),
                  Text("Mahsulot", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Vaqt", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              _buildTableRow("Rustam Axmerov", "Sony A7 III", "10:45", "Berildi"),
              _buildTableRow("Jasmin Abdujamulova", "MacBook Pro", "09:30", "Qaytdi"),
              _buildTableRow("Shavkat Sapashov", "GoPro Hero 11", "08:15", "Berildi"),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String mijoz, String item, String time, String status) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 12.0), child: Text(mijoz)),
        Text(item),
        Text(time),
        Text(status, style: TextStyle(color: status == "Berildi" ? Colors.blue : Colors.green, fontWeight: FontWeight.bold)),
      ],
    );
  }
}