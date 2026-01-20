import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_routes.dart';
import 'logout_title.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();

    // LayoutBuilder orqali ota-ona vidjet bergan kenglikni aniqlaymiz
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCollapsed = constraints.maxWidth < 100;
        return Drawer(
          child: Column(
            children: [
              // SideMenu ichidagi ListView boshiga:
              SizedBox(
                height: isCollapsed ? 80 : 100, // Kichrayganda balandlikni kamaytiramiz
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain, // Rasmni ajratilgan joyga sig'diradi
                  ),
                ),
              ),
              Divider(color: Colors.white10), // Logo va menyularni ajratish uchun chiziq
              Expanded(
                child: ListView(
                  children: [
                    _buildMenuItem(
                      context,
                      title: "Dashboard sahifasi",
                      svgSrc: "assets/icons/menu_dashboard.svg",
                      route: AppRoutes.dashboard,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                    _buildMenuItem(
                      context,
                      title: "Mijozlar",
                      svgSrc: "assets/icons/menu_tran.svg",
                      route: AppRoutes.customers,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                    _buildMenuItem(
                      context,
                      title: "Ijaraga berish",
                      svgSrc: "assets/icons/menu_notification.svg",
                      route: AppRoutes.cart,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                    _buildMenuItem(
                      context,
                      title: "Texnikalar",
                      svgSrc: "assets/icons/menu_task.svg",
                      route: AppRoutes.equipment,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                    _buildMenuItem(
                      context,
                      title: "Ijaraga libertarian",
                      svgSrc: "assets/icons/menu_doc.svg",
                      route: AppRoutes.rentals,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                    _buildMenuItem(
                      context,
                      title: "Band qilinganlar",
                      svgSrc: "assets/icons/menu_store.svg",
                      route: AppRoutes.bookings,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                    _buildMenuItem(
                      context,
                      title: "Buzilgan",
                      svgSrc: "assets/icons/menu_profile.svg",
                      route: AppRoutes.damaged,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                    _buildMenuItem(
                      context,
                      title: "Xodimlar",
                      svgSrc: "assets/icons/menu_setting.svg",
                      route: AppRoutes.staff,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                    _buildMenuItem(
                      context,
                      title: "Hisobot",
                      svgSrc: "assets/icons/menu_notification.svg",
                      route: AppRoutes.reports,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                    _buildMenuItem(
                      context,
                      title: "Akkaunt",
                      svgSrc: "assets/icons/menu_profile.svg",
                      route: AppRoutes.account,
                      currentRoute: currentRoute,
                      isCollapsed: isCollapsed,
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10),
              LogoutTile(isCollapsed: isCollapsed),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  _buildMenuItem(
    BuildContext context, {
    required String title,
    required String svgSrc,
    required String route,
    required String currentRoute,
    required bool isCollapsed,
  }) {
    final bool isActive = currentRoute.startsWith(route);

    return DrawerListTile(
      title: title,
      svgSrc: svgSrc,
      isActive: isActive,
      isCollapsed: isCollapsed, // Yangi parametr
      press: () => context.go(route),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    this.isActive = false,
    this.isCollapsed = false, // Standart holatda keng yozilgan
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool isActive;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      // Kichrayganda paddinglarni nolga tushirish (markazlashtirish uchun)
      contentPadding: isCollapsed
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 16),
      horizontalTitleGap: isCollapsed ? 0.0 : 10.0,
      selected: isActive,
      selectedTileColor: Colors.white10,
      // Icon markazda bo'lishi uchun isCollapsed bo'lganda Center vidjetiga o'raymiz
      leading: isCollapsed
          ? SizedBox(
              width: 60, // ListTile ichidagi leading kengligi
              child: Center(child: _buildIcon()),
            )
          : _buildIcon(),
      // ENG MUHIM JOYI: isCollapsed bo'lsa title ni null qilamiz, shunda ListTile faqat icon ko'rsatadi
      title: isCollapsed
          ? null
          : Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white54,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
    );
  }

  // Iconni qayta-qayta yozmaslik uchun alohida metod
  Widget _buildIcon() {
    return SvgPicture.asset(
      svgSrc,
      colorFilter: ColorFilter.mode(
        isActive ? Colors.white : Colors.white54,
        BlendMode.srcIn,
      ),
      height: 20,
    );
  }
}
