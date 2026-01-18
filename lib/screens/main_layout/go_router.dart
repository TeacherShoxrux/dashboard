// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
//
// final goRouter = GoRouter(
//   initialLocation: '/dashboard',
//   navigatorKey: _rootNavigatorKey,
//   routes: [
//     StatefulShellRoute.indexedStack(
//       builder: (context, state, navigationShell) {
//         // Bu yerda sizning Sidebar/Drawer joylashgan asosiy Layout bo'ladi
//         return MainLayout(navigationShell: navigationShell);
//       },
//       branches: [
//         // 1. Dashboard
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: '/dashboard',
//               builder: (context, state) => const DashboardScreen(),
//             ),
//           ],
//         ),
//         // 2. Mijozlar
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: '/customers',
//               builder: (context, state) => const CustomersScreen(),
//             ),
//           ],
//         ),
//         // 3. Texnikalar
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: '/equipment',
//               builder: (context, state) => const EquipmentScreen(),
//             ),
//           ],
//         ),
//         // 4. Ijaraga berilganlar
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: '/rentals',
//               builder: (context, state) => const RentalsScreen(),
//             ),
//           ],
//         ),
//         // 5. Band qilinganlar (Booking)
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: '/bookings',
//               builder: (context, state) => const BookingsScreen(),
//             ),
//           ],
//         ),
//         // Qolgan barcha menyu elementlarini (Savatcha, Xodimlar va h.k.)
//         // xuddi shu tartibda branch sifatida qo'shib chiqasiz.
//       ],
//     ),
//   ],
// );