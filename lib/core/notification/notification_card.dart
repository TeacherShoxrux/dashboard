import 'package:flutter/material.dart';
import 'app_notification.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  const NotificationCard(this.notification);

  @override
  Widget build(BuildContext context) {
    final color = switch (notification.type) {
      NotificationType.success => Colors.green,
      NotificationType.error => Colors.red,
      _ => Colors.blue,
    };

    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black26,
          ),
        ],
      ),
      child: Text(
        notification.message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
