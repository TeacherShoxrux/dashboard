import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({
    Key? key,
    required this.isCollapsed,
  }) : super(key: key);

  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // Chiqish mantiqi (masalan, tokenni o'chirish va login sahifasiga yuborish)
        _showLogoutDialog(context);
      },
      horizontalTitleGap: isCollapsed ? 0.0 : 10.0,
      leading: isCollapsed
          ? SizedBox(
        width: 60,
        child: const Center(
          child: Icon(Icons.logout, color: Colors.redAccent, size: 22),
        ),
      )
          : const Icon(Icons.logout, color: Colors.redAccent, size: 22),
      title: isCollapsed
          ? null
          : const Text(
        "Chiqish",
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Chiqish"),
        content: const Text("Haqiqatan ham akkauntdan chiqmoqchimisiz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yo'q"),
          ),
          TextButton(
            onPressed: () {
              // GoRouter orqali login sahifasiga o'tish
              // context.go('/login');
            },
            child: const Text("Ha", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}