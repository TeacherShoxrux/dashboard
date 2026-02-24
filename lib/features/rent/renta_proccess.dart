import 'package:admin/features/rent/provider/rent_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RentalProcessWidget extends StatefulWidget {
  const RentalProcessWidget({super.key});

  @override
  State<RentalProcessWidget> createState() => _RentalProcessWidgetState();
}

class _RentalProcessWidgetState extends State<RentalProcessWidget> {
// Checkbox holatlari
  bool _isShiftPriceEnabled = false;
  bool _isNightShiftEnabled = false;
  bool _isPrepaymentEnabled = false;

// Qiymatlar uchun controllerlar
  final TextEditingController _shiftPriceController = TextEditingController();
  final TextEditingController _nightShiftController = TextEditingController();
  final TextEditingController _prepaymentController = TextEditingController();

  @override
  void dispose() {
    _shiftPriceController.dispose();
    _nightShiftController.dispose();
    _prepaymentController.dispose();
    super.dispose();
  }
  String _selectedPayment = "Naqt";
  final List<String> _uploadedImages = [
    "https://via.placeholder.com/150",
    "https://via.placeholder.com/150",
    "https://via.placeholder.com/150",
    "https://via.placeholder.com/150",
    "https://via.placeholder.com/150",
  ];

  @override
  Widget build(BuildContext context) {
    final rentProvider =
        Provider.of<RentNotifierProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161A33).withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF40E0D0).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF40E0D0).withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Ijaraga berish"),

          _buildCheckboxInput(
            label: "1 smena narxi:",
            isChecked: _isShiftPriceEnabled,
            controller: _shiftPriceController..text=rentProvider.pricePerDay.toString(),
            onToggle: (val) {
              setState(() {
                _isShiftPriceEnabled = val ?? false;
              });
            },
          ),

          const SizedBox(height: 10),

          // 2. Tunggi smena
          _buildCheckboxInput(
            label: "Tunggi smena:",
            isChecked: _isNightShiftEnabled,
            controller: _nightShiftController,
            onToggle: (val) {
              setState(() {
                _isNightShiftEnabled = val ?? false;
                if (!_isNightShiftEnabled) _nightShiftController.clear();
              });
            },
          ),
          const SizedBox(height: 10),
          _buildCheckboxInput(
            label: "Oldindan to'lanadigan summa:",
            isChecked: _isPrepaymentEnabled,
            controller: _prepaymentController,
            onToggle: (val) {
              setState(() {
                _isPrepaymentEnabled = val ?? false;
                if (!_isPrepaymentEnabled) _prepaymentController.clear();
              });
            },
          ),
          const SizedBox(height: 25),

          // 3. To'lov turlari
          const Text("To'lov turi:",
              style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 10),
          _buildPaymentMethods(),
          const SizedBox(height: 25),

          // 4. Rasmlar yuklash qismi
          const Text("Hujjatlar / Rasmlar:",
              style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 10),
          _buildImageUploadSection(),
          const SizedBox(height: 25),

          // 5. Jami ma'lumotlar
          _buildSummaryInfo(),
          const SizedBox(height: 30),
          _buildMainButton(),
        ],
      ),
    );
  }
  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(title,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
  Widget _buildCheckboxInput({
    required String label,
    required bool isChecked,
    required TextEditingController controller,
    required Function(bool?) onToggle,
    Function(String)? onTextChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isChecked ? const Color(0xFF40E0D0).withOpacity(0.05) : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: isChecked
                ? const Color(0xFF40E0D0).withOpacity(0.5)
                : Colors.white10,
            width: 1),
      ),
      child: Row(
        children: [
          // Checkbox va Labelni birga bosiladigan qilish
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => onToggle(!isChecked),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: const Color(0xFF40E0D0),
                    checkColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    value: isChecked,
                    onChanged: onToggle,
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isChecked ? Colors.white : Colors.white54,
                        fontSize: 14,
                        fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Input qismi
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: TextField(
                controller: controller,
                enabled: isChecked,
                onChanged: onTextChanged,
                keyboardType: TextInputType.number,
                // Faqat raqamlar kiritish uchun
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                decoration: InputDecoration(
                  suffixText: "so'm",
                  suffixStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                  filled: true,
                  fillColor: isChecked ? Colors.white.withOpacity(0.07) : Colors.black26,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF40E0D0), width: 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPaymentMethods() {
    return Row(
      children: [
        _paymentBtn("Naqt", Icons.account_balance_wallet),
        const SizedBox(width: 10),
        _paymentBtn("Plastik", Icons.credit_card),
        const SizedBox(width: 10),
        _paymentBtn("Terminal", Icons.point_of_sale),
      ],
    );
  }

  Widget _paymentBtn(String label, IconData icon) {
    bool isSelected = _selectedPayment == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPayment = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF40E0D0).withOpacity(0.1)
                : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected ? const Color(0xFF40E0D0) : Colors.white10),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: isSelected ? const Color(0xFF40E0D0) : Colors.white38,
                  size: 20),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white38,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildImageUploadSection() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _uploadedImages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {}, // Image Picker funksiyasi
              child: Container(
                width: 80,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white10, style: BorderStyle.solid),
                ),
                child: const Icon(Icons.add_a_photo, color: Color(0xFF40E0D0)),
              ),
            );
          }
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: NetworkImage(_uploadedImages[index - 1]),
                  fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryInfo() {
    return Consumer<RentNotifierProvider>(
        builder: (context, rentProvider, child) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.05), Colors.transparent]),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            _summaryRow("Jami kunlar:", "${rentProvider.totalDays} kun"),
            const Divider(color: Colors.white10, height: 20),
            _summaryRow("Jami ijara summasi:",
                "${rentProvider.totalPrice} so'm",
                isTotal: true),
          ],
        ),
      );
    });
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white38, fontSize: 14)),
        Text(value,
            style: TextStyle(
                color: isTotal ? const Color(0xFFF4A261) : Colors.white,
                fontSize: isTotal ? 18 : 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Asosiy tugma
  Widget _buildMainButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF40E0D0), Color(0xFF008B8B)]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF40E0D0).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1)
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text(
          "IJARAGA CHIQARISH",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
