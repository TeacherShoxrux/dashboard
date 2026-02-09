import 'package:admin/screens/booking_list/booking_list_page.dart';
import 'package:admin/screens/cart/cart_page.dart';
import 'package:admin/screens/damaged_items/damaged_items_page.dart';
import 'package:admin/screens/employee/employee_page.dart';
import 'package:admin/screens/login/login_page.dart';

import 'package:admin/screens/profile/profile_page.dart';
import 'package:admin/screens/rent/rent_page.dart';
import 'package:admin/screens/rented_list/rented_list_page.dart';
import 'package:admin/screens/reports/reports_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../screens/customers/customers_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/main_layout/main_layout.dart';
import '../../screens/product_selection/product_selection_page.dart';
import '../notification/notification_provider.dart';



class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String customers = '/customers';
  static const String equipment = '/equipment';
  static const String rentals = '/rentals';
  static const String bookings = '/bookings';
  static const String cart = '/cart';
  static const String damaged = '/damaged';
  static const String rent = '/rents';
  static const String staff = '/staff';
  static const String reports = '/reports';
  static const String account = '/account';

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
 static final goRouterProvider = Provider<GoRouter>((ref) {
    return GoRouter(

      initialLocation: login,
      navigatorKey: ref.watch(rootNavigatorKeyProvider),
      debugLogDiagnostics: true,
      routes: [

        GoRoute(path: AppRoutes.login, builder: (context, state) => LoginPage()),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return  MainLayout(navigationShell: navigationShell);

          },
          branches: [
            _buildBranch(dashboard, DashboardPage()),
            _buildBranch(customers, CustomersScreen()),
            _buildBranch(equipment, ProductSelectionScreen()),
            _buildBranch(rentals, RentedListPage()),
            _buildBranch(bookings, BookingListPage()),
            _buildBranch(cart, CartPage()),
            _buildBranch(rent, RentPage()),
            _buildBranch(damaged, const DamagedItemsPage()),
            _buildBranch(staff, const EmployeesPage()),
            _buildBranch(reports, const ReportsPage()),
            _buildBranch(account, const ProfilePage()),
          ],
        ),
      ],
    );
  });
  static StatefulShellBranch _buildBranch(String path, Widget screen) {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: path,
          builder: (context, state) => screen,
        ),
      ],
    );
  }
}
