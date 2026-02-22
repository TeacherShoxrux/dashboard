import 'package:admin/features/equipments/domain/models/category_model.dart';
import 'package:admin/features/equipments/ui/providers/repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/add_brand_dialog.dart';
import 'components/add_category_alert.dart';
import 'components/add_product_alert.dart';
import 'components/product_card.dart';

class ProductSelectionScreen extends StatefulWidget {
  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {


  final TextEditingController _searchController = TextEditingController();

  final Map<String, List<Map<String, String>>> categories = {
    "Apple": [
      {"name": "iPhone", "img": "https://img.com/iphone.png"},
      {"name": "MacBook", "img": "https://img.com/mac.png"},
    ],
  };
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EquipmentProvider>().init();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EquipmentProvider>();
    return Scaffold(
        body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Mahsulotlarni izlash...",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0), // Balandlikni muvozanatlash
                              ),
                            ),
                          ),
                          const SizedBox(width: 12), // Oradagi masofa
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const AddProductDialog(),
                              );
                            },
                            icon: const Icon(Icons.add_box),
                            label: const Text("Mahsulot qo'shish"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 18),
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

                 SliverToBoxAdapter(
                            child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Text("Brendlar",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const AddBrandDialog(),
                                      );
                                    },
                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.green, size: 28),
                                    tooltip: "Brend qo'shish",
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.brands.length,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                itemBuilder: (context, index) {
                                  var isSelected=provider.selectedBrand?.id== provider.brands[index].id;
                                  return GestureDetector(
                                    onTap: () {
                                      provider.getCategories(provider.brands[index].id);
                                      provider.selectedBrand= provider.brands[index];
                                      provider.getAllEquipments(brandId: provider.brands[index].id);
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      width: 80,
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        // Tanlangan bo'lsa ko'k fon, bo'lmasa oq
                                        color:
                                            // isSelected ? Colors.blue.withOpacity(0.1) :
                                            Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        // Tanlangan bo'lsa ko'k chegara
                                        border: Border.all(
                                            color:
                                                // isSelected ? Colors.blue :
                                                Colors.grey[300]!,
                                            width: 2),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.business,
                                            color:
                                                isSelected ? Colors.blue :
                                                Colors.grey,
                                          ),
                                          Text(
                                            provider.brands[index].name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  isSelected ? Colors.blue :
                                                  Colors.grey[700],
                                              fontSize: 12,
                                              fontWeight:
                                                 isSelected ? FontWeight.bold :
                                                  FontWeight.normal,
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
                        )),


                  // SliverToBoxAdapter(),

                  // 3. KATEGORIYALAR (Horizontal Scroll)
                  if(provider.selectedBrand != null)
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start, // Matn va tugmani ikki chetga suradi
                              children: [
                                Text(
                                    "Kategoriyalar ${provider.selectedBrand != null ? "(${provider.selectedBrand?.name})" : ""}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                // Matn yonidagi + tugmasi
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const AddCategoryDialog(),
                                    );
                                  },
                                  icon: const Icon(Icons.add_circle,
                                      color: Colors.green, size: 28),
                                  tooltip: "Kategoriya qo'shish",
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.category.length,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              itemBuilder: (context, index) {
                                var cat = provider.category[index];
                                bool isSelected = provider.selectedCategory?.id == cat.id;
                                return GestureDetector(
                                  onTap: () {
                                    provider.selectedCategory = cat;
                                    provider.getAllEquipments(categoryId: cat.id);

                                  },
                                  child: Card(
                                    color: isSelected
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: isSelected
                                              ? Colors.orange
                                              : Colors.black54),
                                    ),
                                    child: Container(
                                      width: 100,
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: Icon(Icons.category,
                                                  size: 40,
                                                  color: Colors.orange)),
                                          Text(cat.name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
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
                  Consumer<EquipmentProvider>(
                      builder:(context,state,child)=> SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ProductCard(
                          name: provider.equipments[index].name,
                          subName:
                              "${provider.equipments[index].brandName} / ${provider.equipments[index].categoryName}",
                          price: "${provider.equipments[index].pricePerDay}",
                        );
                      }, childCount: provider.equipments.length
                          ),
                    ),
                  )),
                ],
              ),
    );

  }
}
