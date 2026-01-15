import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  DateTimeRange? selectedRange;
  String reportType = "Umumiy daromad";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tizim hisobotlari",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // 1. FILTRLAR PANELI (Backendga yuboriladigan ma'lumotlar)
            _buildFilterPanel(),

            const SizedBox(height: 30),

            // 2. ASOSIY STATISTIKA KARTALARI
            _buildStatCards(),

            const SizedBox(height: 30),

            // 3. DAROMAD GRAFIGI VA TOVARLAR ANALITIKASI
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRevenueChart()),
                const SizedBox(width: 24),
                Expanded(flex: 1, child: _buildTopProductsList()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Filtrlar paneli
  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          // Sana tanlash
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now(),
                  builder: (context, child) => _buildResponsivePicker(context, child!),
                );
                if (range != null) setState(() => selectedRange = range);
              },
              icon: const Icon(Icons.date_range),
              label: Text(selectedRange == null
                  ? "Sana oralig'ini tanlang"
                  : "${selectedRange!.start.toString().split(' ')[0]} - ${selectedRange!.end.toString().split(' ')[0]}"),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
            ),
          ),
          const SizedBox(width: 16),
          // Hisobot turi
          Expanded(
            child: DropdownButtonFormField<String>(
              value: reportType,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Hisobot turi"),
              items: ["Umumiy daromad", "Tovarlar bo'yicha", "Xodimlar bo'yicha", "Qarzdorlik"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => reportType = v!),
            ),
          ),
          const SizedBox(width: 16),
          // Backendga yuborish tugmasi
          ElevatedButton.icon(
            onPressed: () {
              // Backendga selectedRange va reportType yuboriladi
            },
            icon: const Icon(Icons.analytics),
            label: const Text("Hisobotni shakllantirish"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
        ],
      ),
    );
  }

  // Statistika kartalari (Summary Cards)
  Widget _buildStatCards() {
    return Row(
      children: [
        _statCard("Jami daromad", "45,000,000 so'm", Icons.trending_up, Colors.green),
        const SizedBox(width: 16),
        _statCard("Ijaralar soni", "128 ta", Icons.shopping_bag, Colors.blue),
        const SizedBox(width: 16),
        _statCard("Mijozlar", "+12 ta yangi", Icons.people, Colors.orange),
        const SizedBox(width: 16),
        _statCard("Qarzdorlik", "3,200,000 so'm", Icons.warning, Colors.red),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.indigoAccent, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(
              color: Colors.white,
            )),
            Text(value, style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Grafik o'rni (Placeholder)
  Widget _buildRevenueChart() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Daromad dinamikasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Spacer(),
          Center(child: Text("Bu yerda fl_chart grafigi bo'ladi", style: TextStyle(color: Colors.grey))),
          const Spacer(),
        ],
      ),
    );
  }

  // Eng ko'p daromad keltirgan tovarlar
  Widget _buildTopProductsList() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top tovarlar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  onTap: () {},
                  
                  leading: CircleAvatar(child: Text("${index+1}")),
                  title: const Text("Sony A7 III"),
                  subtitle: const Text("12 marta ijara"),
                  trailing: const Text("5.4 mln", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Responsive Calendar Dialog uchun builder
  Widget _buildResponsivePicker(BuildContext context, Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: child,
      ),
    );
  }
}