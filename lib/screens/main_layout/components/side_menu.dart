import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_routes.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          _buildMenuItem(
            context,
            title: "Dashboard sahifasi",
            svgSrc: "assets/icons/menu_dashboard.svg",
            route: AppRoutes.dashboard,
            currentRoute: currentRoute,
          ),
          _buildMenuItem(
            context,
            title: "Mijozlar",
            svgSrc: "assets/icons/menu_tran.svg",
            route: AppRoutes.customers,
            currentRoute: currentRoute,
          ),
          _buildMenuItem(
            context,
            title: "Texnikalar",
            svgSrc: "assets/icons/menu_task.svg",
            route: AppRoutes.equipment,
            currentRoute: currentRoute,
          ),
          _buildMenuItem(
            context,
            title: "Ijaraga berilganlar",
            svgSrc: "assets/icons/menu_doc.svg",
            route: AppRoutes.rentals,
            currentRoute: currentRoute,
          ),
          _buildMenuItem(
            context,
            title: "Band qilinganlar",
            svgSrc: "assets/icons/menu_store.svg",
            route: AppRoutes.bookings,
            currentRoute: currentRoute,
          ),
          _buildMenuItem(
            context,
            title: "Band qilish",
            svgSrc: "assets/icons/menu_notification.svg",
            route: AppRoutes.cart,
            currentRoute: currentRoute,
          ),
          _buildMenuItem(
            context,
            title: "Buzilgan",
            svgSrc: "assets/icons/menu_profile.svg",
            route: AppRoutes.damaged,
            currentRoute: currentRoute,
          ),
          _buildMenuItem(
            context,
            title: "Xodimlar",
            svgSrc: "assets/icons/menu_setting.svg",
            route: AppRoutes.staff,
            currentRoute: currentRoute,
          ),
          _buildMenuItem(
            context,
            title: "Hisobot",
            svgSrc: "assets/icons/menu_notification.svg",
            route: AppRoutes.reports,
            currentRoute: currentRoute,
          ),
          _buildMenuItem(
            context,
            title: "Akkaunt",
            svgSrc: "assets/icons/menu_profile.svg",
            route: AppRoutes.account,
            currentRoute: currentRoute,
          ),
        ],
      ),
    );
  }
  Widget _buildMenuItem(
      BuildContext context, {
        required String title,
        required String svgSrc,
        required String route,
        required String currentRoute,
      }) {
    final bool isActive = currentRoute.startsWith(route);

    return DrawerListTile(
      title: title,
      svgSrc: svgSrc,
      isActive: isActive,
      press: () {
        context.go(route);
      },
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    this.isActive = false, // Aktivlik holati qo'shildi
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      // Tanlangan menyu uchun orqa fon rangi
      selected: isActive,
      selectedTileColor: Colors.white10,
      leading: SvgPicture.asset(
        svgSrc,
        // Aktiv bo'lganda rangni yorqinroq qilish
        colorFilter: ColorFilter.mode(
          isActive ? Colors.white : Colors.white54,
          BlendMode.srcIn,
        ),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white54,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}