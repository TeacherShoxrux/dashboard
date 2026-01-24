import 'package:flutter/material.dart';

class Customer {
  final String name, phone, date, takenDate;
  Customer(this.name, this.phone, this.date, this.takenDate);
}

class AdvancedCustomerSearch extends StatefulWidget {
  const AdvancedCustomerSearch({super.key});

  @override
  State<AdvancedCustomerSearch> createState() => _AdvancedCustomerSearchState();
}

class _AdvancedCustomerSearchState extends State<AdvancedCustomerSearch> {
  final List<Customer> _allCustomers = [
    Customer("Javohir Qudratov", "90 123 45 67", "24.01.2026", "24.01.2026"),
    Customer("Sardor Ismoilov", "91 987 65 43", "24.01.2026", ""),
    Customer("Nodir Akramov", "94 444 22 11", "24.01.2026", ""),
    Customer("Alisher Valiyev", "93 111 22 33", "25.01.2026", "25.01.2026"),
  ];
  final List<Customer> _selectedCustomers = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1221).withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Mijozni tanlash",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add),
                label: const Text(""),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
            ],
          ),
          const Text("Tanlanganlar:", style: TextStyle(color: Colors.white38, fontSize: 13)),
          const SizedBox(height: 10),

          _selectedCustomers.isEmpty
              ?     RawAutocomplete<Customer>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') return const Iterable<Customer>.empty();
              return _allCustomers.where((Customer option) {
                return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                    option.phone.contains(textEditingValue.text);
              });
            },
            displayStringForOption: (Customer option) => option.name,

            // Natijalar oynasi dizayni
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 410, // Input kengligi bilan bir xil
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F3D),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Customer option = options.elementAt(index);
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: Icon(Icons.person, color: Color(0xFFF9A825), size: 20),
                          ),
                          title: Text(option.name, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(option.phone, style: const TextStyle(color: Colors.white38)),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },

            // Qidiruv maydoni dizayni
            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Ism yoki telefon raqami...",
                  hintStyle: TextStyle(color: Colors.white24),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF40E0D0)),
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

            onSelected: (Customer selection) {
              setState(() {
                if (!_selectedCustomers.contains(selection)) {
                  _selectedCustomers.add(selection);
                }
              });
            },
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedCustomers.length,
            itemBuilder: (context, index) {
              return _buildSelectedCard(_selectedCustomers[index], index);
            },
          ),
        ],
      ),
    );
  }

  // Tanlangan mijoz kartasi (Glow effekti bilan)
  Widget _buildSelectedCard(Customer customer, int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ekran kengligiga qarab o'lchamlarni belgilaymiz
        bool isMobile = constraints.maxWidth < 450;
        double horizontalPadding = isMobile ? 12 : 20;

        return Column(
          children: [
            // 1. ASOSIY MA'LUMOTLAR BLOKI
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 2),
              padding: EdgeInsets.all(horizontalPadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: const Color(0xFF40E0D0).withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF40E0D0).withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar (Responsive o'lcham)
                      Container(
                        width: isMobile ? 45 : 55,
                        height: isMobile ? 45 : 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.3),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Icon(
                            Icons.person,
                            color: const Color(0xFFF4A261),
                            size: isMobile ? 24 : 30
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Ism va Telefon
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 16 : 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              customer.phone,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      // Yopish tugmasi
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white24, size: 20),
                        onPressed: () => setState(() => _selectedCustomers.removeAt(index)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pastki qatorlar (Responsive offset bilan)
                  _buildInfoLine(
                      "Ijaraga berilgan sana:", "24.01.2026",
                      leftOffset: isMobile ? 61 : 71
                  ),
                  _buildInfoLine(
                      "Olib ketilgan vaqt:", "10:15",
                      leftOffset: isMobile ? 61 : 71
                  ),
                  _buildInfoLine(
                      "Qarzi:", "0 so'm",
                      leftOffset: isMobile ? 61 : 71,
                      valueColor: const Color(0xFFF4A261)
                  ),
                ],
              ),
            ),

            // 2. PASPORT MA'LUMOTLAR BLOKI (Glassmorphism)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                border: Border.all(color: const Color(0xFF40E0D0).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  // Pasport ikonka
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7E4C7).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.badge_outlined, color: Color(0xFFB7E4C7), size: 20),
                  ),
                  const SizedBox(width: 12),

                  // Pasport matnlari
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pasport: ID karta | Fedoya O567447",
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Ofisda",
                          style: TextStyle(color: Color(0xFFB7E4C7), fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.keyboard_arrow_down, color: Colors.white24, size: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

// Responsive yordamchi metod
  Widget _buildInfoLine(String label, String value, {required double leftOffset, Color valueColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(width: leftOffset),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor, fontSize: 12, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}