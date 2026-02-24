import 'dart:async';

import 'package:admin/features/equipments/domain/models/equipment_model.dart';
import 'package:admin/features/rent/provider/rent_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../equipments/ui/providers/repository_provider.dart';

class EquipmentSearchWidget extends StatefulWidget {
  const EquipmentSearchWidget({super.key});

  @override
  State<EquipmentSearchWidget> createState() => _EquipmentSearchWidgetState();
}

class _EquipmentSearchWidgetState extends State<EquipmentSearchWidget> {
  Timer? _debounceTimer;
  final equipmentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final equipmentProvider =
        Provider.of<EquipmentProvider>(context, listen: false);
    final rentProvider =
        Provider.of<RentNotifierProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1221).withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Texnikalarni qidirish",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Autocomplete<EquipmentModel>(
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<EquipmentModel>.empty();
              }
              if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

              final completer = Completer<Iterable<EquipmentModel>>();
              _debounceTimer = Timer(const Duration(seconds: 2), () async {
                try {
                  await equipmentProvider.getAllEquipments(search: textEditingValue.text);
                  completer.complete(equipmentProvider.equipments);
                } catch (e) {
                  completer.complete(const Iterable<EquipmentModel>.empty());
                }
              });

              return completer.future;
            },
            displayStringForOption: (EquipmentModel option) => option.name,
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 460,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F3D),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final EquipmentModel option = options.elementAt(index);
                        return ListTile(
                          leading: const Icon(Icons.bolt, color: Colors.white54, size: 20),
                          title: Text(option.name, style: const TextStyle(color: Colors.white)),
                          subtitle: Text("${option.pricePerDay} so'm",
                              style: const TextStyle(color: Colors.white38)),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },

            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
               onFieldSubmitted: (e){
                  controller.clear();
               },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Texnika nomini yozing...",
                  hintStyle: const TextStyle(color: Colors.white24),
                  prefixIcon: const Icon(Icons.construction, color: Color(0xFF40E0D0)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF40E0D0), width: 1.5),
                  ),
                ),
              );
            },

            // 4. Element tanlanganda bajariladigan ishlar
            onSelected: (EquipmentModel selection) {
              rentProvider.addEquipment(selection);
              Future.microtask(() {
                // Bu yerda o'zgaruvchi orqali TextField'ni tozalaymiz
                // fieldViewBuilder'dagi 'controller' aslida Autocomplete tomonidan boshqariladi
              });

              // Muhim: AutocompleteField tanlovdan so'ng textni o'chirishi uchun
              // widget state-ni yangilash kerak yoki controller.clear() chaqirish kerak.
            },
          ),
          const SizedBox(height: 25),
          Consumer<RentNotifierProvider>(
              builder: (context, rentProvider, child) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rentProvider.equipmentSelectedList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white10,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        rentProvider.equipmentSelectedList[index]
                                    .availableCount ==
                                0
                            ? Icons.check_box_outlined
                            : Icons.indeterminate_check_box_outlined,
                        color: rentProvider.equipmentSelectedList[index]
                                    .availableCount ==
                                0
                            ? const Color(0xFF40E0D0)
                            : Colors.white24,
                        size: 20,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rentProvider.equipmentSelectedList[index].name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rentProvider
                                  .equipmentSelectedList[index].pricePerDay
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.white24, size: 18),
                        onPressed: () => rentProvider.removeEquipment(
                            rentProvider.equipmentSelectedList[index]),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
