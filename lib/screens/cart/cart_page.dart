import 'package:flutter/material.dart';

import 'components/equipment_autocomplete.dart';
import 'components/rental_checkout.dart';

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
// Bu ma'lumotlar odatda Backend'dan (API orqali) keladi
  final List<EquipmentModel> myProducts = [
    EquipmentModel(
      name: "Bosch GSB 13 RE",
      brand: "Bosch",
      category: "Drellar",
      imageUrl: "https://example.com/bosch.jpg",
      stockCount: 15,
    ),
    EquipmentModel(
      name: "Makita HR2470",
      brand: "Makita",
      category: "Perforatorlar",
      imageUrl: "https://example.com/makita.jpg",
      stockCount: 0,
    ),
  ];
  final List<EquipmentModel> selectedProducts = [];
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
                  EquipmentAutocomplete(
                    suggestions: myProducts,
                    onSelected: (EquipmentModel selectedProduct) {
                     selectedProducts.add(selectedProduct);
                     setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedProducts.length,
                      itemBuilder: (context, index) {
                        var item = selectedProducts[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(child: Icon(Icons.inventory_2)),
                            title: Text(item.name),
                            subtitle: Text("${item.stockCount} so'm / kun"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () => setState(() => item.stockCount++ > 1 ? item.stockCount-- : null),
                                ),
                                Text("${item.stockCount}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                  onPressed: () => setState(() => item.stockCount++),
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
  IconButton(onPressed: (){
    showDialog(context: context, builder: (context) => RentalCheckoutDialog());
  }, icon: Icon(Icons.menu))
        ],
      ),
    );
  }
}