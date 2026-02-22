import 'package:admin/features/equipments/domain/models/category_model.dart';
import 'package:admin/features/equipments/ui/providers/repository_provider.dart';
import 'package:admin/features/equipments/ui/providers/widgets/brands_widget.dart';
import 'package:admin/features/equipments/ui/providers/widgets/category_widget.dart';
import 'package:admin/network/api_constants.dart';
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
          BrandsWidget(),
          if (provider.selectedBrand != null) CategoryWidget(),
          Consumer<EquipmentProvider>(
              builder: (context, state, child) => SliverPadding(
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
                      }, childCount: provider.equipments.length),
                    ),
                  )),
        ],
      ),
    );
  }
}
