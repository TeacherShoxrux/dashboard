import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../network/api_constants.dart';
import '../../components/add_brand_dialog.dart';
import '../repository_provider.dart';

class BrandsWidget extends StatelessWidget {
  const BrandsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EquipmentProvider>();
    return SliverToBoxAdapter(
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
                    onPressed: ()async {
                      var res = await showDialog(
                          context: context,
                          builder: (context) =>
                          const AddBrandDialog());
                      if(res==true){
                        provider.getAllBrands();
                      }
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
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    children: provider.brands.map( (e) {
                      var isSelected=provider.selectedBrand?.id== e.id;
                      return GestureDetector(
                          onTap: () {
                            provider.getCategories(e.id);
                            provider.selectedBrand= e;
                            provider.getAllEquipments(brandId: e.id);
                          },
                          child:AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 100, // 80 biroz kichiklik qilishi mumkin, 100 qulayroq
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey[300]!,
                                width: 2,
                              ),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Borderdan 2px kichikroq
                              child: Stack(
                                children: [
                                  // 1. Rasm (Agar mavjud bo'lsa)
                                  if (e.imageUrl != null)
                                    Positioned.fill(
                                      child: Image.network(
                                        ApiConstants.baseUrl + e.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, color: Colors.grey),
                                      ),
                                    ),

                                  // 2. Gradient (Matn o'qilishi uchun qatlam)
                                  if (e.imageUrl != null)
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.1),
                                              Colors.black.withOpacity(0.6),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  // 3. Kontent (Icon va Matn)
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (e.imageUrl == null)
                                            Icon(
                                              Icons.business,
                                              color: isSelected ? Colors.blue : Colors.grey,
                                              size: 30,
                                            ),
                                          const Spacer(), // Matnni pastga surish uchun
                                          Text(
                                            e.name,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: e.imageUrl != null ? Colors.white : (isSelected ? Colors.blue : Colors.grey[800]),
                                              fontSize: 11,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                              shadows: e.imageUrl != null
                                                  ? [const Shadow(color: Colors.black, blurRadius: 4)]
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      );
                    },).toList(),
                  )
              ),
            ),
          ],
        ));
  }
}
