import 'package:admin/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // --- MAIN ACTION BUTTONS ---

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildActionCard(
                    title: "Ijaraga\nberish",
                    icon: Icons.add,
                    color: const Color(0xFF16A34A),
                      context: context,
                  onPressed: ()=>context.go(AppRoutes.cart)
                ),
                _buildActionCard(
                    title: "Qabul\nqilish",
                    icon: Icons.remove,
                    color: Colors.purple,
                    context: context,
                    isGradient: true,
                    onPressed: ()=>context.go(AppRoutes.cart)
                ),
                _buildActionCard(
                    title: "Band qilish",
                    icon: Icons.calendar_today,
                    color: const Color(0xFFEA580C),
                    onPressed:()=> context.go(AppRoutes.cart),
                    context: context),
              ],
            ),
            const SizedBox(height: 24),

            // --- STATISTICS CARDS ---
            Wrap(
              spacing: 12.0, // Gorizontal oraliq
              runSpacing: 12.0, // Vertikal oraliq (keyingi qatorga o'tganda)
              alignment: WrapAlignment.start,
              children: [
                _buildCompactStatCard(
                    "Faol ijaralar", "42 ta", Icons.description, Colors.blue),
                _buildCompactStatCard("Bugungi tushum", "1,260,000 so'm",
                    Icons.attach_money, Colors.green),
                _buildCompactStatCard("Band qilinganlar", "15 ta",
                    Icons.event_available, Colors.orange),
                _buildCompactStatCard(
                    "Qarzdorlar", "8 ta", Icons.error_outline, Colors.red),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Header vidjeti
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      toolbarHeight: 80, // Balandlikni Wrap uchun yetarli qilib belgilaymiz
      automaticallyImplyLeading:
          false, // Default orqaga qaytish tugmasini o'chirish
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 12,
        // alignment: WrapAlignment.spaceBetween,
        // crossAxisAlignment: WrapCrossAlignment.center,
        // runSpacing: 12,
        children: [
          // VAQT VA SANA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Shanba, 24 Yanvar 2026",
                    style: TextStyle(color: Colors.grey, fontSize: 10)),
                Text("15 : 15",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // KURS (Faqat keng ekranlarda ko'rinadi yoki Wrap orqali pastga tushadi)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Ichki kurs: 100 \$ = 1 200 000 so'm (faqat admin kiritadi)",
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
            ),
          ),

          // PROFIL VA BILDIRIShNOMA
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Text("O'z.ru ", style: TextStyle(fontSize: 13)),
                    Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle)),
                    const Text(" Admin",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Stack(
                children: [
                  const Icon(Icons.notifications_none,
                      color: Colors.white70, size: 24),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Katta tugmalar uchun vidjet
  Widget _buildActionCard(
      {required String title,
      required IconData icon,
      required Color color,
      required BuildContext context,
      bool isGradient = false,
      VoidCallback? onPressed}) {
    double cardWidth = MediaQuery.of(context).size.width > 600
        ? 280
        : (MediaQuery.of(context).size.width - 64) / 2;
    // Mobil ekranda tugma kengligi biroz kattaroq, lekin chegaralangan bo'ladi

    // Agar ekran juda kichik bo'lsa (masalan iPhone SE), 160px dan kam bo'lmasligi kerak
    // if (cardWidth < 160) cardWidth = MediaQuery.of(context).size.width - 48;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGradient ? null : color,
        gradient: isGradient
            ? const LinearGradient(
                colors: [Color(0xFFA21CAF), Color(0xFFDB2777)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pastki statistika kartalari uchun vidjet
  Widget _buildCompactStatCard(
      String title, String value, IconData icon, Color color) {
    // Kartaning maksimal kengligini belgilaymiz (masalan, 250-280 atrofida yaxshi turadi)
    return Container(
      width: 240, // Karta juda kengayib ketmasligi uchun aniq kenglik
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        // Balandlikni kamaytirish uchun Row-dan foydalanamiz
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Bo'sh joyni tejash
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
