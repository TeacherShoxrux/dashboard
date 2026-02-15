import 'package:flutter/material.dart';

class EquipmentAutocomplete extends StatelessWidget {
  final List<EquipmentModel> suggestions;
  final Function(EquipmentModel) onSelected;

  const EquipmentAutocomplete({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( // Responsive qilish uchun
      builder: (context, constraints) {
        return Autocomplete<EquipmentModel>(
          displayStringForOption: (EquipmentModel option) => option.name,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<EquipmentModel>.empty();
            }
            return suggestions.where((EquipmentModel option) {
              return option.name
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: onSelected,

          // Qidiruv maydoni (Input field)
          fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Mahsulot qidirish...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                // fillColor: Colors.grey[100],
              ),
            );
          },

          // Natijalar chiqadigan qism (Dropdown list)
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: constraints.maxWidth, // Input kengligi bilan bir xil qiladi
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (BuildContext context, int index) {
                      final EquipmentModel option = options.elementAt(index);
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            option.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${option.brand} • ${option.category}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${option.stockCount} dona",
                              style: TextStyle(
                                color: option.stockCount > 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text("Zaxirada", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class EquipmentModel {
  final String name;
  final String brand;
  final String category;
  final String imageUrl;
   int stockCount;

  EquipmentModel({
    required this.name,
    required this.brand,
    required this.category,
    required this.imageUrl,
    required this.stockCount,
  });
}