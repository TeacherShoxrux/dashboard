import 'dart:async';

import 'package:admin/features/customers/models/customer_model.dart';
import 'package:admin/features/rent/provider/rent_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customers/provider/customer_notifier.dart';

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
CustomerModel? selectedCustomer;
  final List<Customer> _selectedCustomers = [];
  Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerNotifierProvider>(context);
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

       selectedCustomer==null
              ?     RawAutocomplete<CustomerModel>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<CustomerModel>.empty();
              }
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              final completer = Completer<Iterable<CustomerModel>>();
              _debounce = Timer(const Duration(seconds: 3), () async {
                try {
                  await customerProvider.getAllCustomers(search:textEditingValue.text,size: 10,page: 1);
                  completer.complete(customerProvider.customers);
                } catch (e) {
                  completer.complete(const Iterable<CustomerModel>.empty());
                }
              });
              return completer.future;
            },
            displayStringForOption: (CustomerModel option) => option.firstName,
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 410,
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
                        final CustomerModel option = options.elementAt(index);
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: Icon(Icons.person, color: Color(0xFFF9A825), size: 20),
                          ),
                          title: Text(option.firstName, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(option.firstName, style: const TextStyle(color: Colors.white38)),
                          onTap: () => onSelected(option),
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

            onSelected: (CustomerModel selection) {
              setState(() {
                if (selectedCustomer == null) {
                  selectedCustomer=selection;
                }
              });
            },
          )
              : _buildSelectedCard(selectedCustomer!)

        ],
      ),
    );
  }

  Widget _buildSelectedCard(CustomerModel customer) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 450;
        double horizontalPadding = isMobile ? 12 : 20;
        return Column(
          children: [
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
                              customer.firstName + " " + customer.lastName,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 16 : 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              customer.address??'',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      // Yopish tugmasi
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white24, size: 20),
                        onPressed: () => selectedCustomer=null,
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