import 'package:flutter/material.dart';

class ReturnRentalWidget extends StatefulWidget {
  const ReturnRentalWidget({super.key});

  @override
  State<ReturnRentalWidget> createState() => _ReturnRentalWidgetState();
}

class _ReturnRentalWidgetState extends State<ReturnRentalWidget> {
  // Tanlangan mahsulotlarni kuzatish uchun map
  final Map<int, bool> _selectedItems = {0: true, 1: true, 2: false};
  String _paymentType = 'Naqd';
  final TextEditingController _paymentController = TextEditingController(text: "50,000");

  // Mahsulotlar ro'yxati (Sample data)
  final List<Map<String, dynamic>> _items = [
    {
      "name": "Generator Honda 3kW",
      "price": "90,000 so'm",
      "qty": "1 ta",
      "img": "https://cdn-icons-png.flaticon.com/512/2979/2979339.png"
    },
    {
      "name": "Beton aralashtirgich",
      "price": "120,000 so'm",
      "qty": "1 ta",
      "img": "https://cdn-icons-png.flaticon.com/512/2762/2762589.png"
    },
    {
      "name": "Perforator Bosch",
      "price": "50,000 so'm",
      "qty": "2 ta",
      "img": "https://cdn-icons-png.flaticon.com/512/2301/2301140.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1221),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF161A33).withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Mijoz va muddat"),
                  _buildCustomerInfo(),
                  const SizedBox(height: 25),

                  _buildSectionTitle("Qaytariladigan mahsulotlar"),
                  _buildProductList(),
                  const SizedBox(height: 25),

                  _buildSectionTitle("Hisob-kitob"),
                  _buildSummarySection(),
                  const SizedBox(height: 25),

                  _buildSectionTitle("To'lovni yakunlash"),
                  _buildPaymentSection(),
                  const SizedBox(height: 30),

                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Mijoz va vaqt ma'lumotlari
  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF40E0D0).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF2B354F),
            child: Icon(Icons.person, color: Color(0xFFF9A825)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Javohir Qudratov", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text("Olib ketilgan: 20.01.2026 | 09:00", style: TextStyle(color: Colors.white38, fontSize: 13)),
                Text("Qaytarilish vaqti : 20.01.2026 | 09:00", style: TextStyle(color: Colors.white38, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mahsulotlar ro'yxati (Checkbox bilan)
  Widget _buildProductList() {
    return Column(
      children: List.generate(_items.length, (index) {
        final item = _items[index];
        bool isSelected = _selectedItems[index] ?? false;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF40E0D0).withOpacity(0.05) : Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF40E0D0).withOpacity(0.4) : Colors.white10,
            ),
          ),
          child: Column(
            children: [
              // 1-QATOR: Checkbox, Rasm va Asosiy ma'lumotlar
              Row(
                children: [
                  Checkbox(
                    activeColor: const Color(0xFF40E0D0),
                    checkColor: Colors.black,
                    value: isSelected,
                    onChanged: (val) => setState(() => _selectedItems[index] = val!),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item['img'],
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.handyman, color: Colors.white24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(item['price'], style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),

                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.redAccent, size: 20))
                ],
              ),

              if (isSelected) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Colors.white10, height: 1),
                ),

                // 2-QATOR: Soni (Counter) va Holati (Dropdown)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // --- SONINI O'ZGARTIRISH (COUNTER) ---
                    Row(
                      children: [
                        const Text("Soni:", style: TextStyle(color: Colors.white60, fontSize: 13)),
                        const SizedBox(width: 8),
                        _buildQtyBtn(Icons.remove, () {
                          // Soni kamaytirish mantiqi shu yerda
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text("${item['qty']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        _buildQtyBtn(Icons.add, () {
                          // Soni oshirish mantiqi shu yerda
                        }),
                      ],
                    ),


                    // --- HOLATI (STATUS DROPDOWN) ---
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white.withOpacity(0.05),
                    //     borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(color: Colors.white10),
                    //   ),
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton<String>(
                    //       value: item['status'] ?? 'Yaxshi', // Default holat
                    //       dropdownColor: const Color(0xFF1A1F3D),
                    //       icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF40E0D0)),
                    //       style: const TextStyle(color: Colors.white, fontSize: 13),
                    //       items: ['Yaxshi', 'Singan', 'Buzilgan'].map((String value) {
                    //         return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Text(value),
                    //         );
                    //       }).toList(),
                    //       onChanged: (newValue) {
                    //         setState(() {
                    //           item['status'] = newValue;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

// Counter uchun kichik tugma yordamchisi
  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  // Ijara summasi va to'langan summa
  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _buildSummaryRow("Umumiy ijara summasi:", "310,000 so'm", Colors.white70),
          const SizedBox(height: 10),
          _buildSummaryRow("To'langan summa:", "260,000 so'm", const Color(0xFF40E0D0)),
          const Divider(color: Colors.white10, height: 25),
          _buildSummaryRow("Qolgan qarz (Jami):", "50,000 so'm", Colors.redAccent, isBold: true),
        ],
      ),
    );
  }

  // To'lov turi va summasi
  Widget _buildPaymentSection() {
    return Row(
      children: [
      // To'lov turi (Dropdown)
      Expanded(
      flex: 2,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  value: _paymentType,
                  dropdownColor: const Color(0xFF1A1F3D),
                  items: ['Naqd', 'Plastik', 'O\'tkazma'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: (String? value) => setState(() => _paymentType = value!),
    ),
    ),
    ),
    ),
    const SizedBox(width: 12),
    // To'lov summasi (Input)
    Expanded(
    flex: 3,
    child: TextField(
    controller: _paymentController,
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    decoration: InputDecoration(
    hintText: "Summani kiriting",
    hintStyle: const TextStyle(color: Colors.white24),
    filled: true,
    fillColor: Colors.white.withOpacity(0.05),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white10)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF40E0D0))),
    ),
    ),
    ),
    ],
    );
  }

  // Qabul va Bekor qilish tugmalari
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), foregroundColor: Colors.redAccent),
            child: const Text("Bekor qilish", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF40E0D0), Color(0xFF008B8B)]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: const Color(0xFF40E0D0).withOpacity(0.3), blurRadius: 12)],
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text("Qabul qilish", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  // Yordamchi metodlar
  Widget _buildSectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)));

  Widget _buildSummaryRow(String label, String value, Color valColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 14)),
        Text(value, style: TextStyle(color: valColor, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 16 : 14)),
      ],
    );
  }
}