import 'package:admin/screens/product_selection/product_card.dart';
import 'package:flutter/material.dart';

class ProductSelectionScreen extends StatefulWidget {
  @override
  _VisualSelectionScreenState createState() => _VisualSelectionScreenState();
}

class _VisualSelectionScreenState extends State<ProductSelectionScreen> {
  String? selectedBrand;
  String? selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  // Namunaviy ma'lumotlar (Bularni bazadan olasiz)
  final List<Map<String, String>> brands = [
    {"name": "Apple", "img": "https://logo.com/apple.png"},
    {"name": "Samsung", "img": "https://logo.com/samsung.png"},
    {"name": "Sony", "img": "https://logo.com/sony.png"},
    {"name": "Canon", "img": "https://logo.com/canon.png"},
    {"name": "HP", "img": "https://logo.com/hp.png"},
  ];

  final Map<String, List<Map<String, String>>> categories = {
    "Apple": [
      {"name": "iPhone", "img": "https://img.com/iphone.png"},
      {"name": "MacBook", "img": "https://img.com/mac.png"},
    ],
    // Boshqa brendlar uchun ham shunday...
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. QIDIRUV TEXTFIELD (Tepada qotib turadi)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // 1. QIDIRUV SATRI
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Mahsulotlarni izlash...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(vertical: 0), // Balandlikni muvozanatlash
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Oradagi masofa

                  // 2. MAHSULOT QO'SHISH TUGMASI
                  ElevatedButton.icon(
                    onPressed: () {
                      print("Yangi mahsulot qo'shish oynasi");
                      // Bu yerda mahsulot qo'shish funksiyasini chaqirasiz
                    },
                    icon: const Icon(Icons.add_box),
                    label: const Text("Mahsulot qo'shish"),
                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. BRENDLAR (Horizontal Scroll)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text("Brendlar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {
                          print("Yangi kategoriya qo'shish bosildi");
                          // Bu yerda dialog yoki yangi sahifani ochishingiz mumkin
                        },
                        icon: const Icon(Icons.add_circle, color: Colors.green, size: 28),
                        tooltip: "Brend qo'shish",
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // Brendlar soniga +1 (Qo'shish tugmasi uchun)
                    itemCount: brands.length,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {

                      int brandIndex = index;
                      bool isSelected = selectedBrand == brands[brandIndex]['name'];

                      return GestureDetector(
                        onTap: () => setState(() {
                          selectedBrand = brands[brandIndex]['name'];
                          selectedCategory = null;
                        }),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            // Tanlangan bo'lsa ko'k fon, bo'lmasa oq
                            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            // Tanlangan bo'lsa ko'k chegara
                            border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!, width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.business,
                                color: isSelected ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                brands[brandIndex]['name']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected ? Colors.blue : Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
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

          // 3. KATEGORIYALAR (Horizontal Scroll)
          if (selectedBrand != null)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start, // Matn va tugmani ikki chetga suradi
                      children: [
                        Text(
                            "Kategoriyalar ${selectedBrand != null ? "($selectedBrand)" : ""}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                        // Matn yonidagi + tugmasi
                        IconButton(
                          onPressed: () {
                            print("Yangi kategoriya qo'shish bosildi");
                            // Bu yerda dialog yoki yangi sahifani ochishingiz mumkin
                          },
                          icon: const Icon(Icons.add_circle, color: Colors.green, size: 28),
                          tooltip: "Kategoriya qo'shish",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories[selectedBrand]?.length ?? 0,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        var cat = categories[selectedBrand]![index];
                        bool isSelected = selectedCategory == cat['name'];
                        return GestureDetector(
                          onTap: () => setState(() => selectedCategory = cat['name']),
                          child: Card(
                            color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: isSelected ? Colors.orange : Colors.black54),
                            ),
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Expanded(child: Icon(Icons.category, size: 40, color: Colors.orange)),
                                  Text(cat['name']!, textAlign: TextAlign.center, style: TextStyle(color:Colors.grey,fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // 4. MAHSULOTLAR (Grid View)
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return ProductCard(
                    name: "MacBook Pro M3",
                    subName: "Noutbuklar / Apple",
                    price: "150,000",
                  );
                },
                childCount: 8, // Filtrlangan mahsulotlar soni
              ),
            ),
          ),
        ],
      ),
    );
  }
}