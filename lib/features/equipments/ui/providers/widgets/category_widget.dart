import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/add_category_alert.dart';
import '../repository_provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EquipmentProvider>();
    return   SliverToBoxAdapter(
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
                  onPressed: ()=>
                    showDialog(
                      context: context,
                      builder: (context) =>
                      const AddCategoryDialog(),
                    )
                  ,
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
    );
  }
}
