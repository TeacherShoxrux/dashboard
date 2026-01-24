import 'package:flutter/material.dart';

class Equipment {
  final String title;
  final String price;
  final String status; // masalan: "93 - faol" yoki "faol emas"
  final bool isActive;
  final IconData icon;

  Equipment({
    required this.title,
    required this.price,
    required this.status,
    required this.isActive,
    required this.icon,
  });
}

class EquipmentSearchWidget extends StatefulWidget {
  const EquipmentSearchWidget({super.key});

  @override
  State<EquipmentSearchWidget> createState() => _EquipmentSearchWidgetState();
}

class _EquipmentSearchWidgetState extends State<EquipmentSearchWidget> {
  // Texnikalar bazasi
  final List<Equipment> _allEquipment = [
    Equipment(title: "Generator Honda 3kW", price: "90 so'm", status: "93 - faol", isActive: true, icon: Icons.bolt),
    Equipment(title: "Beton aralashtirgich", price: "100 so'm", status: "93 - faol", isActive: true, icon: Icons.settings_input_component),
    Equipment(title: "Payvandlash apparati", price: "80 so'm", status: "faol emas", isActive: false, icon: Icons.handyman),
    Equipment(title: "Perforator Bosch", price: "50 so'm", status: "10 - faol", isActive: true, icon: Icons.construction),
  ];

  // Tanlangan texnikalar ro'yxati
  final List<Equipment> _selectedList = [];

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          // --- AUTOCOMPLETE QIDIRUV ---
          RawAutocomplete<Equipment>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') return const Iterable<Equipment>.empty();
              return _allEquipment.where((Equipment option) {
                return option.title.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            displayStringForOption: (Equipment option) => option.title,

            // Qidiruv natijalari dizayni (Dropdown)
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
                        final Equipment option = options.elementAt(index);
                        return ListTile(
                          leading: Icon(option.icon, color: Colors.white54, size: 20),
                          title: Text(option.title, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(option.price, style: const TextStyle(color: Colors.white38)),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },

            // Qidiruv maydoni (Input)
            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Texnika nomini yozing...",
                  hintStyle: const TextStyle(color: Colors.white24),
                  prefixIcon: const Icon(Icons.construction, color: Color(0xFF40E0D0)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF40E0D0), width: 1.5),
                  ),
                ),
              );
            },
            onSelected: (Equipment selection) {
              setState(() {
                if (!_selectedList.contains(selection)) {
                  _selectedList.add(selection);
                }
              });
            },
          ),

          const SizedBox(height: 25),

          // --- TANLANGAN TEXNIKALAR RO'YXATI (RASMGA MOS) ---
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedList.length,
            itemBuilder: (context, index) {
              return _buildEquipmentCard(_selectedList[index], index);
            },
          ),
        ],
      ),
    );
  }

  // Tanlangan texnika kartasi (Rasmda ko'rsatilganidek)
  Widget _buildEquipmentCard(Equipment item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        // Birinchi elementga (yoki tanlanganiga) cyan glow berish mumkin
        border: Border.all(
          color: index == 0 ? const Color(0xFF40E0D0).withOpacity(0.4) : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          // Chap tomondagi belgi (Check yoki Icon)
          Icon(
            item.isActive ? Icons.check_box_outlined : Icons.indeterminate_check_box_outlined,
            color: item.isActive ? const Color(0xFF40E0D0) : Colors.white24,
            size: 20,
          ),
          const SizedBox(width: 15),

          // Nom va Narx
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  item.price,
                  style: const TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ],
            ),
          ),

          // O'ng tomondagi Status Pill (Faol/Faol emas)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: item.isActive
                  ? const Color(0xFF40E0D0).withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.status,
                  style: TextStyle(
                    color: item.isActive ? const Color(0xFF40E0D0) : Colors.redAccent,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  item.isActive ? Icons.check : Icons.close,
                  color: item.isActive ? const Color(0xFF40E0D0) : Colors.redAccent,
                  size: 14,
                ),
              ],
            ),
          ),

          // O'chirish tugmasi
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 18),
            onPressed: () => setState(() => _selectedList.removeAt(index)),
          ),
        ],
      ),
    );
  }
}