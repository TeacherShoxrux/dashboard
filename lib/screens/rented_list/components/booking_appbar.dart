import 'package:flutter/material.dart';

class BookingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookingAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(180); // Balandlikni kengaytiramiz

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0F1221), // Asosiy to'q fon
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1-QATOR: Sarlavha va Bugungi sana
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Band qilingan mahsulotlar (Booking)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildDatePicker(),
              ],
            ),
            const SizedBox(height: 15),

            // 2-QATOR: Vaqt filtrlari va Texnika qidiruvi
            Row(
              children: [
                _buildTimeFilters(),
                const SizedBox(width: 15),
                Expanded(child: _buildSearchFilters()),
              ],
            ),
            const SizedBox(height: 15),

            // 3-QATOR: Status ko'rsatkichlari
            _buildStatusIndicators(),
          ],
        ),
      ),
    );
  }

  // Bugungi sana tanlagichi
  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: const [
          Icon(Icons.calendar_month, color: Color(0xFF40E0D0), size: 18),
          SizedBox(width: 8),
          Text(
            "Bugungi sana: 24-yanvar, 2026",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          Icon(Icons.keyboard_arrow_down, color: Colors.white38),
        ],
      ),
    );
  }

  // Kunlik, Haftalik, Oylik tablari
  Widget _buildTimeFilters() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          _buildTabItem("Kunlik", isSelected: true, icon: Icons.calendar_view_day),
          _buildTabItem("Haftalik", icon: Icons.calendar_view_week),
          _buildTabItem("Oylik", icon: Icons.calendar_view_month),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, {bool isSelected = false, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isSelected ? Border.all(color: Colors.blueAccent.withOpacity(0.5)) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.white38, size: 16),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(color: isSelected ? Colors.white : Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // Texnika turi va Kamera filtri
  Widget _buildSearchFilters() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          const Icon(Icons.biotech, color: Color(0xFF40E0D0), size: 18),
          const SizedBox(width: 8),
          const Text("Texnika turi", style: TextStyle(color: Colors.white70)),
          const VerticalDivider(color: Colors.white10, indent: 10, endIndent: 10),
          const Icon(Icons.camera_alt, color: Color(0xFF40E0D0), size: 18),
          const SizedBox(width: 8),
          const Text("Kamera", style: TextStyle(color: Colors.white70)),
          const Spacer(),
          const Icon(Icons.search, color: Colors.white38),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  // Status ko'rsatkichlari (Tasdiqlangan, Kutilmoqda...)
  Widget _buildStatusIndicators() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _statusItem(Colors.green, "Tasdiqlangan: 12"),
          const SizedBox(width: 20),
          _statusItem(Colors.orange, "Kutilmoqda: 5"),
          const SizedBox(width: 20),
          _statusItem(Colors.red, "Bekor qilingan: 2"),
        ],
      ),
    );
  }

  Widget _statusItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}