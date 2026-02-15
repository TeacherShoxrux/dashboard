import 'package:admin/features/cart/customer_search.dart';
import 'package:admin/features/cart/side.dart';
import 'package:flutter/material.dart';

import 'components/equipment_autocomplete.dart';
import 'components/rental_checkout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'equipment_search.dart';

// void main() => runApp(const MaterialApp(home: RentFormPage(), debugShowCheckedModeBanner: false));

// --- MODELLAR ---
class Client {
  final String name, surname, passport, license;
  Client(this.name, this.surname, this.passport, this.license);
  @override
  String toString() => '$name $surname';
}

class Machine {
  final String category, imageUrl, price;
  final int count;
  Machine(this.category, this.imageUrl, this.count, this.price);
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _RentFormPageState();
}

class _RentFormPageState extends State<CartPage> {
  Client? selectedClient;
  List<Machine> selectedMachines = [];
  DateTimeRange? selectedDateRange=DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 19)));
  TimeOfDay startTime = const TimeOfDay(hour: 09, minute: 00);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 00);
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      // appBar: AppBar(title: const Text("Ijaraga berish"), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: isMobile
            ? Column(children: [_mainContent(), const SizedBox(height: 20), CalendarSidePanel()])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 2, child: _mainContent()),
          const SizedBox(width: 20),
          Expanded(flex: 1, child: CalendarSidePanel()),
        ]),
      ),
      // bottomNavigationBar: _buildRentButton(),
    );
  }

  // --- ASOSIY QISM (MIJOZ VA TEXNIKA) ---
  Widget _mainContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // _sectionTitle("Mijozni tanlang"),
      AdvancedCustomerSearch(),
      //
      // const SizedBox(height: 10),
      //
      //
      // const SizedBox(height: 30),
      // _sectionTitle("Texnikalar qidirish"),
      EquipmentSearchWidget()
    ]);
  }

  // --- YON PANEL (DATE PICKER VA VAQT) ---
  Widget _sidePanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _sectionTitle("Muddatni tanlang"),
        ElevatedButton(
          onPressed: () async {
            final picked = await showDateRangePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030));
            if (picked != null) setState(() => selectedDateRange = picked);
          },
          child: const Text("Kalendarni ochish"),
        ),
        if (selectedDateRange != null) ...[
          const SizedBox(height: 20),
          _dateInfo("Boshlanish:", selectedDateRange!.start, startTime, () => _selectTime(true)),
          const Divider(color: Colors.white24),
          _dateInfo("Tugash:", selectedDateRange!.end, endTime, () => _selectTime(false)),
        ]
      ]),
    );
  }

  // --- YORDAMCHI WIDGETLAR ---
  Widget _buildClientDetails() {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListTile(
        title: Text("${selectedClient!.name} ${selectedClient!.surname}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text("Pasport: ${selectedClient!.passport}\nGuvohnoma: ${selectedClient!.license}", style: const TextStyle(color: Colors.white70)),
      ),
    );
  }

  Widget _buildMachineList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedMachines.length,
      itemBuilder: (ctx, i) => ListTile(
        leading: Image.network(selectedMachines[i].imageUrl, width: 40),
        title: Text(selectedMachines[i].category),
        subtitle: Text("Narxi: ${selectedMachines[i].price} so'm"),
        trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => selectedMachines.removeAt(i))),
      ),
    );
  }

  Widget _machineOptions(Iterable<Machine> options, Function(Machine) onSelected) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: const Color(0xFF1E293B),
        child: SizedBox(
          width: 400,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (ctx, i) {
              final m = options.elementAt(i);
              return ListTile(
                leading: Image.network(m.imageUrl, width: 30),
                title: Text(m.category),
                subtitle: Text("Soni: ${m.count} | Narxi: ${m.price}"),
                onTap: () => onSelected(m),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _dateInfo(String label, DateTime date, TimeOfDay time, VoidCallback onTimeTap) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(DateFormat('dd.MM.yyyy').format(DateTime.now()), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      TextButton.icon(
        onPressed: onTimeTap,
        icon: const Icon(Icons.access_time),
        label: Text("Soat: ${time.format(context)}"),
      ),
    ]);
  }

  Widget _buildRentButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(20)),
        onPressed: () {},
        child: const Text("IJARAGA BERISH", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _selectTime(bool isStart) async {
    final picked = await showTimePicker(context: context, initialTime: isStart ? startTime : endTime);
    if (picked != null) setState(() => isStart ? startTime = picked : endTime = picked);
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint, prefixIcon: Icon(icon),
      filled: true, fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
  );
}





// class CartPage extends StatefulWidget {
//   @override
//   _CartPageState createState() => _CartPageState();
// }
//
// class _CartPageState extends State<CartPage> {
//   DateTimeRange? selectedRange; // Ijara kunlari oralig'i
//   String paymentMethod = "Naqd"; // To'lov turi
//   bool isBooking = false; // Rent yoki Booking tanlovi
//
//   // Namunaviy savatdagi mahsulotlar
//   List<Map<String, dynamic>> cartItems = [
//     {"name": "Sony A7III", "price": 150000, "qty": 1, "sub": "Kameralar"},
//     {"name": "24-70mm Lens", "price": 80000, "qty": 1, "sub": "Obyektivlar"},
//   ];
//
//   int get totalDays => selectedRange?.duration.inDays ?? 1;
//
//   double get totalPrice {
//     double sum = 0;
//     for (var item in cartItems) {
//       sum += item['price'] * item['qty'];
//     }
//     return sum * totalDays;
//   }
//   final List<Map<String, String>> allCustomers = [
//     {"name": "Ali Valiyev", "phone": "+998 90 123 45 67"},
//     {"name": "Javohir Kudratov", "phone": "+998 91 777 00 11"},
//     {"name": "Rustam Axmerov", "phone": "+998 93 555 22 33"},
//   ];
// // Bu ma'lumotlar odatda Backend'dan (API orqali) keladi
//   final List<EquipmentModel> myProducts = [
//     EquipmentModel(
//       name: "Bosch GSB 13 RE",
//       brand: "Bosch",
//       category: "Drellar",
//       imageUrl: "https://example.com/bosch.jpg",
//       stockCount: 15,
//     ),
//     EquipmentModel(
//       name: "Makita HR2470",
//       brand: "Makita",
//       category: "Perforatorlar",
//       imageUrl: "https://example.com/makita.jpg",
//       stockCount: 0,
//     ),
//   ];
//   final List<EquipmentModel> selectedProducts = [];
//   double paidAmount=0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.grey[50],
//       body: Row(
//         children: [
//           // 1. CHAP TOMON: Mahsulotlar ro'yxati va miqdori
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Savat", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 20),
//                   EquipmentAutocomplete(
//                     suggestions: myProducts,
//                     onSelected: (EquipmentModel selectedProduct) {
//                      selectedProducts.add(selectedProduct);
//                      setState(() {});
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: selectedProducts.length,
//                       itemBuilder: (context, index) {
//                         var item = selectedProducts[index];
//                         return Card(
//                           margin: EdgeInsets.only(bottom: 12),
//                           child: ListTile(
//                             leading: CircleAvatar(child: Icon(Icons.inventory_2)),
//                             title: Text(item.name),
//                             subtitle: Text("${item.stockCount} so'm / kun"),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.remove_circle_outline, color: Colors.red),
//                                   onPressed: () => setState(() => item.stockCount++ > 1 ? item.stockCount-- : null),
//                                 ),
//                                 Text("${item.stockCount}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                                 IconButton(
//                                   icon: Icon(Icons.add_circle_outline, color: Colors.green),
//                                   onPressed: () => setState(() => item.stockCount++),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // 2. O'NG TOMON: Hisob-kitob va To'lov (Sidebar style)
//   IconButton(onPressed: (){
//     showDialog(context: context, builder: (context) => RentalCheckoutDialog());
//   }, icon: Icon(Icons.menu))
//         ],
//       ),
//     );
//   }
// }