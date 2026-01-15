import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DateTimeRange? selectedRange; // Ijara kunlari oralig'i
  String paymentMethod = "Naqd"; // To'lov turi
  bool isBooking = false; // Rent yoki Booking tanlovi

  // Namunaviy savatdagi mahsulotlar
  List<Map<String, dynamic>> cartItems = [
    {"name": "Sony A7III", "price": 150000, "qty": 1, "sub": "Kameralar"},
    {"name": "24-70mm Lens", "price": 80000, "qty": 1, "sub": "Obyektivlar"},
  ];

  int get totalDays => selectedRange?.duration.inDays ?? 1;

  double get totalPrice {
    double sum = 0;
    for (var item in cartItems) {
      sum += item['price'] * item['qty'];
    }
    return sum * totalDays;
  }
  final List<Map<String, String>> allCustomers = [
    {"name": "Ali Valiyev", "phone": "+998 90 123 45 67"},
    {"name": "Javohir Kudratov", "phone": "+998 91 777 00 11"},
    {"name": "Rustam Axmerov", "phone": "+998 93 555 22 33"},
  ];

  double paidAmount=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // 1. CHAP TOMON: Mahsulotlar ro'yxati va miqdori
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Savat", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        var item = cartItems[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(child: Icon(Icons.inventory_2)),
                            title: Text(item['name']),
                            subtitle: Text("${item['price']} so'm / kun"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () => setState(() => item['qty'] > 1 ? item['qty']-- : null),
                                ),
                                Text("${item['qty']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                  onPressed: () => setState(() => item['qty']++),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. O'NG TOMON: Hisob-kitob va To'lov (Sidebar style)
          Container(
            width: 400,
            color: Colors.indigo.withOpacity(0.5),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rasmiylashtirish", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(height: 10),
                Text("Mijozni tanlang:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                Autocomplete<Map<String, String>>(
                  displayStringForOption: (Map<String, String> option) =>
                  "${option['name']} (${option['phone']})",
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<Map<String, String>>.empty();
                    }
                    // Bu yerda bazadagi (masalan Firebase) mijozlar ro'yxatidan qidiriladi
                    return allCustomers.where((Map<String, String> option) {
                      return option['name']!.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                          option['phone']!.contains(textEditingValue.text);
                    });
                  },
                  onSelected: (Map<String, String> selection) {
                    print('Tanlangan mijoz: ${selection['name']}');
                    setState(() {
                      // Tanlangan mijozni saqlash mantiqi
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "Mijoz ismi yoki tel...",
                        prefixIcon: Icon(Icons.person_search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.blue[50]?.withOpacity(0.3),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: SizedBox(
                          width: 352, // TextField kengligiga moslash
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Map<String, String> option = options.elementAt(index);
                              return ListTile(
                                leading: CircleAvatar(child: Text(option['name']![0])),
                                title: Text(option['name']!),
                                subtitle: Text(option['phone']!),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5),

                // Ijara turi (Rent yoki Booking)
                Text("Turi:", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    ChoiceChip(
                      label: Text("Hozir berish (Rent)"),
                      selected: !isBooking,
                      onSelected: (v) => setState(() => isBooking = false),
                    ),
                    SizedBox(width: 10),
                    ChoiceChip(
                      label: Text("Band qilish (Booking)"),
                      selected: isBooking,
                      onSelected: (v) => setState(() => isBooking = true),
                    ),
                  ],
                ),
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

                // To'lov turi

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


                // Text("To'lov turi:", style: TextStyle(fontWeight: FontWeight.bold)),
                // DropdownButtonFormField<String>(
                //   value: paymentMethod,
                //   items: ["Naqd", "Karta (UzCard/Humo)", "Click/Payme", "Terminal"]
                //       .map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                //   onChanged: (v) => setState(() => paymentMethod = v!),
                // ),

                // To'lov turidan keyin va Spacer dan oldin joylashtiring
                const SizedBox(height: 20),


                const Spacer(),

                // Yakuniy hisob
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kunlar soni:"),
                    Text("$totalDays kun"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Umumiy summa:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("${totalPrice.toStringAsFixed(0)} so'm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: isBooking ? Colors.orange : Colors.green),
                    onPressed: () {
                      // Baza bilan bog'lash funksiyasi
                    },
                    child: Text(isBooking ? "Band qilishni tasdiqlash" : "Ijarani boshlash", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}