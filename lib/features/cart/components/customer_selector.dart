import 'package:flutter/material.dart';

class CustomerSelector extends StatefulWidget {
  @override
  _CustomerSelectorState createState() => _CustomerSelectorState();
}

class _CustomerSelectorState extends State<CustomerSelector> {
  // Barcha mijozlar (odatda bazadan keladi)
  final List<Map<String, String>> allCustomers = [
    {'id': '1', 'name': 'Ali Valiev', 'phone': '+998901234567'},
    {'id': '2', 'name': 'Olim Toshov', 'phone': '+998939876543'},
    {'id': '3', 'name': 'Aziza Karimova', 'phone': '+998941112233'},
  ];

  // Tanlangan mijozlar ro'yxati
  List<Map<String, String>> selectedCustomers = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Mijozni tanlang:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // --- AUTOCOMPLETE QISMI ---
        Autocomplete<Map<String, String>>(
          displayStringForOption: (option) => "", // Tanlangandan keyin TextField bo'sh qolishi uchun
          optionsBuilder: (textValue) {
            if (textValue.text == '') return const Iterable.empty();
            return allCustomers.where((opt) {
              // Allaqachon tanlangan mijozlarni qidiruvda chiqarmaslik
              bool isAlreadySelected = selectedCustomers.any((s) => s['id'] == opt['id']);
              return !isAlreadySelected &&
                  (opt['name']!.toLowerCase().contains(textValue.text.toLowerCase()) ||
                      opt['phone']!.contains(textValue.text));
            });
          },
          onSelected: (selection) {
            setState(() {
              selectedCustomers.add(selection);
            });
            // TextField-ni tozalash uchun Controller-dan foydalanish mumkin
          },
          optionsViewBuilder: (context, onSelected, options){
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  // width: constraints.maxWidth, // Input kengligi bilan bir xil qiladi
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (BuildContext context, int index) {

                      return ListTile(
                        // leading: ClipRRect(
                        //   borderRadius: BorderRadius.circular(8),
                        //   child: Image.network(
                        //     option.imageUrl,
                        //     width: 50,
                        //     height: 50,
                        //     fit: BoxFit.cover,
                        //     errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
                        //   ),
                        // ),
                        title: Text("${options.elementAt(index)["name"]} • ", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${options.elementAt(index)["phone"]} • "),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Text(
                            //   "${option.stockCount} dona",
                            //   style: TextStyle(
                            //     color: option.stockCount > 0 ? Colors.green : Colors.red,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            const Text("Zaxirada", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        onTap: () =>setState(()=>selectedCustomers.add(options.elementAt(index))) ,
                      );
                    },
                  ),
                ),
              ),
            );


          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Ism yoki tel...",
                prefixIcon: Icon(Icons.person_search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                // fillColor: Colors.grey[50],
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        if (selectedCustomers.isNotEmpty)
          Column(
            children: selectedCustomers.map((e){
              final customer=e;
              return ListTile(
                title: Text(customer['name']!),
                subtitle: Text(customer['phone']!),
                trailing:IconButton(onPressed: () => setState(() => selectedCustomers.remove(customer)), icon: Icon(Icons.close,color: Colors.red,))
              );
            }).toList(),
          )
      ],
    );
  }
}