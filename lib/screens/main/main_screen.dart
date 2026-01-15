import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../booking_list/booking_list_page.dart';
import '../customers/customers_screen.dart';
import '../product_selection/product_selection_page.dart';
import '../rented_list/rented_list_page.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  // Sahifalar ro'yxati
  final List<Widget> _pages = [
    DashboardScreen(),
    CustomersScreen(), // ProductsScreen()
    ProductSelectionScreen(),
    RentedListPage(),
    BookingListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Kontrollerni kuzatib turamiz
    var menuController = context.watch<MenuAppController>();

    return Scaffold(
      key: menuController.scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: IndexedStack(
                index: menuController.selectedIndex, // Tanlangan indeksga qarab sahifa almashadi
                children: _pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// controllers/menu_app_controller.dart ichiga qo'shing:





