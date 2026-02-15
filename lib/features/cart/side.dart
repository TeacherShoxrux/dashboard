import 'package:flutter/material.dart';

class CalendarSidePanel extends StatelessWidget {
  const CalendarSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.9), // To'q binafsha fon
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        // image: const DecorationImage(
        //   image: NetworkImage('https://your-space-bg-link.com'), // Orqa fondagi yulduzli effekt uchun
        //   fit: BoxFit.cover,
        //   opacity: 0.1,
        // ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- KALENDAR QISMI ---
          _buildCalendarHeader(),
          const SizedBox(height: 10),
          _buildWeekDays(),
          _buildDateGrid(),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: _buildOkButton(),
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          const SizedBox(height: 10),

          // --- VAQT TANLASH QISMI ---
          _buildTimeSelector("Olib ketish vaqti", Icons.access_time, "09:00"),
          const SizedBox(height: 12),
          _buildTimeSelector("Olib kelish vaqti", Icons.error_outline, "17:00", iconColor: Colors.orangeAccent),

          const SizedBox(height: 12),

          Text("3-kun"),
          const SizedBox(height: 12),
          Row(
            children: [
              // Expanded(child: _buildSecondaryButton("Bekor qilish")),
              // const SizedBox(width: 12),
              Expanded(child: _buildPrimaryButton("Band qilish")),
            ],
          ),
        ],
      ),
    );
  }

  // Kalendar Tepasi (Oy va Navigatsiya)
  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.arrow_back_ios, color: Colors.white54, size: 16),
        Text(
          "Yanvar 2026",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      ],
    );
  }

  // Haftaning kunlari
  Widget _buildWeekDays() {
    final days = ['Du', 'Se', 'Cho', 'Pa', 'Ju', 'Sh', 'Ya'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) => Expanded(
          child: Center(child: Text(day, style: TextStyle(color: Colors.white38, fontSize: 12))),
        )).toList(),
      ),
    );
  }

  // Kunlar setkasi
  Widget _buildDateGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 31,
      itemBuilder: (context, index) {
        int day = index + 1;
        bool isSelectedRange = day >= 21 && day <= 24;
        bool isStart = day == 21;
        bool isEnd = day == 24;

        return Container(
          decoration: BoxDecoration(
            color: isSelectedRange ? Colors.green.withOpacity(0.3) : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: isStart ? Radius.circular(8) : Radius.zero,
              right: isEnd ? Radius.circular(8) : Radius.zero,
            ),
            border: isSelectedRange ? Border.all(color: Colors.greenAccent.withOpacity(0.5)) : null,
          ),
          child: Center(
            child: Text(
              "$day",
              style: TextStyle(
                color: isSelectedRange ? Colors.greenAccent : (day < 10 ? Colors.white24 : Colors.white70),
                fontWeight: isSelectedRange ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOkButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
      ),
      child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  // Vaqt tanlovchi field
  Widget _buildTimeSelector(String title, IconData icon, String time, {Color iconColor = Colors.white54}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(color: Colors.white70)),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              const SizedBox(width: 30),
              Text(time, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white70))),
    );
  }

  Widget _buildPrimaryButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF1565C0)]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8)],
      ),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }
}