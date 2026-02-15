import 'package:flutter/material.dart';

// Mijoz modeli
class Customer {
  final String name;
  final String phone;
  final String date;
  final String? takenDate;

  Customer({required this.name, required this.phone, required this.date, this.takenDate});
}

class CustomerSearchWidget extends StatefulWidget {
  const CustomerSearchWidget({super.key});

  @override
  State<CustomerSearchWidget> createState() => _CustomerSearchWidgetState();
}

class _CustomerSearchWidgetState extends State<CustomerSearchWidget> {
  // Barcha mijozlar ro'yxati (Bazada bo'ladigan ma'lumotlar)
  final List<Customer> _allCustomers = [
    Customer(name: "Javohir Qudratov", phone: "90 123 45 67", date: "24.01.2026", takenDate: "24.01.2026"),
    Customer(name: "Sardor Ismoilov", phone: "91 987 65 43", date: "24.01.2026"),
    Customer(name: "Nodir Akramov", phone: "94 444 22 11", date: "24.01.2026"),
    Customer(name: "Alisher Valiyev", phone: "93 555 33 22", date: "25.01.2026"),
  ];

  // Qidiruv natijasida ko'rinadigan ro'yxat
  List<Customer> _filteredCustomers = [];
  int? _selectedIndex = 0; // Birinchisi tanlangan turishi uchun

  @override
  void initState() {
    super.initState();
    _filteredCustomers = _allCustomers; // Boshida hamma mijozlarni ko'rsatish
  }

  // Qidiruv mantiqi
  void _filterCustomers(String query) {
    setState(() {
      _filteredCustomers = _allCustomers
          .where((customer) =>
      customer.name.toLowerCase().contains(query.toLowerCase()) ||
          customer.phone.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1221).withOpacity(0.95), // Rasmdagi to'q fon
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // --- QIDIRUV MAYDONI ---
          _buildSearchField(),
          const SizedBox(height: 20),

          // --- MIJOZLAR RO'YXATI ---
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500), // Maksimal balandlik
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return _buildCustomerCard(customer, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // TextField vidjeti
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        onChanged: _filterCustomers, // Har bir harf yozilganda qidiradi
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Mijozni qidirish",
          hintStyle: TextStyle(color: Colors.white38),
          prefixIcon: Icon(Icons.search, color: Colors.white38),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  // Mijoz kartasi vidjeti
  Widget _buildCustomerCard(Customer customer, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(18),
          // Tanlangan bo'lsa firuza nur (Glow) effekti
          border: Border.all(
            color: isSelected ? const Color(0xFF40E0D0).withOpacity(0.6) : Colors.white10,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF40E0D0).withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 2,
            )
          ]
              : [],
        ),
        child: Row(
          children: [
            // Avatar qismi
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [const Color(0xFF2B354F), const Color(0xFF1A2033).withOpacity(0.8)],
                ),
                border: Border.all(color: Colors.white10),
              ),
              child: const Icon(Icons.person, color: Color(0xFFF9A825), size: 30),
            ),
            const SizedBox(width: 15),

            // Ma'lumotlar qismi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        customer.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        customer.date,
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer.phone,
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  if (customer.takenDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      "Olib ketilgan sana: ${customer.takenDate}",
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }
}