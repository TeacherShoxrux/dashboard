import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/responsive.dart';
import 'package:admin/features/cart/cart_page.dart';
import 'package:admin/features/damaged_items/damaged_items_page.dart';
import 'package:admin/features/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../booking_list/booking_list_page.dart';
import '../customers/customers_screen.dart';
import '../employee/employee_page.dart';
import '../product_selection/product_selection_page.dart';
import '../profile/profile_page.dart';
import '../rented_list/rented_list_page.dart';
import '../reports/reports_page.dart';
import 'components/side_menu.dart';

class MainLayout extends StatelessWidget {

  final StatefulNavigationShell navigationShell;
   MainLayout({super.key, required this.navigationShell});
   Widget menu=SideMenu();
  @override
  Widget build(BuildContext context) {
    var menuController = context.watch<MenuAppController>();

    return Scaffold(
      key: menuController.scaffoldKey,
      appBar: Responsive.isDesktop(context)?null:AppBar(),
      drawer: menu,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             if (Responsive.isDesktop(context))
              Expanded(
                child:menu,
              ),
            Expanded(
                flex: 5,
                child: navigationShell),
          ],
        ),
      ),
    );
  }
}
// controllers/menu_app_controller.dart ichiga qo'shing:





