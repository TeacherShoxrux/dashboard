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
                label: const Text("Yangi mijoz qo'shish"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
            ],
          ),
          // const SizedBox(height: 15),

          // --- AUTOCOMPLETE QIDIRUV ---
          // RawAutocomplete<Customer>(
          //   optionsBuilder: (TextEditingValue textEditingValue) {
          //     if (textEditingValue.text == '') return const Iterable<Customer>.empty();
          //     return _allCustomers.where((Customer option) {
          //       return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
          //           option.phone.contains(textEditingValue.text);
          //     });
          //   },
          //   displayStringForOption: (Customer option) => option.name,
          //
          //   // Natijalar oynasi dizayni
          //   optionsViewBuilder: (context, onSelected, options) {
          //     return Align(
          //       alignment: Alignment.topLeft,
          //       child: Material(
          //         color: Colors.transparent,
          //         child: Container(
          //           width: 410, // Input kengligi bilan bir xil
          //           margin: const EdgeInsets.only(top: 5),
          //           decoration: BoxDecoration(
          //             color: const Color(0xFF1A1F3D),
          //             borderRadius: BorderRadius.circular(15),
          //             border: Border.all(color: Colors.white10),
          //             boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
          //           ),
          //           child: ListView.builder(
          //             padding: EdgeInsets.zero,
          //             shrinkWrap: true,
          //             itemCount: options.length,
          //             itemBuilder: (BuildContext context, int index) {
          //               final Customer option = options.elementAt(index);
          //               return ListTile(
          //                 leading: const CircleAvatar(
          //                   backgroundColor: Colors.white10,
          //                   child: Icon(Icons.person, color: Color(0xFFF9A825), size: 20),
          //                 ),
          //                 title: Text(option.name, style: const TextStyle(color: Colors.white)),
          //                 subtitle: Text(option.phone, style: const TextStyle(color: Colors.white38)),
          //                 onTap: () => onSelected(option),
          //               );
          //             },
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          //
          //   // Qidiruv maydoni dizayni
          //   fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          //     return TextField(
          //       controller: controller,
          //       focusNode: focusNode,
          //       style: const TextStyle(color: Colors.white),
          //       decoration: InputDecoration(
          //         hintText: "Ism yoki telefon raqami...",
          //         hintStyle: TextStyle(color: Colors.white24),
          //         prefixIcon: const Icon(Icons.search, color: Color(0xFF40E0D0)),
          //         filled: true,
          //         fillColor: Colors.white.withOpacity(0.05),
          //         enabledBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(15),
          //           borderSide: const BorderSide(color: Colors.white10),
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(15),
          //           borderSide: const BorderSide(color: Color(0xFF40E0D0), width: 1.5),
          //         ),
          //       ),
          //     );
          //   },
          //
          //   onSelected: (Customer selection) {
          //     setState(() {
          //       if (!_selectedCustomers.contains(selection)) {
          //         _selectedCustomers.add(selection);
          //       }
          //     });
          //   },
          // ),
          //
          // const SizedBox(height: 25),

          // --- TANLANGAN MIJOZLAR RO'YXATI ---
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF40E0D0).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF40E0D0).withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF40E0D0), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(customer.phone, style: const TextStyle(color: Colors.white60, fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white24, size: 20),
            onPressed: () => setState(() => _selectedCustomers.removeAt(index)),
          ),
        ],
      ),
    );
  }
}