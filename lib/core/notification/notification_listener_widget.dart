import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_notification.dart';
import 'notification_notifier.dart';

class NotificationListenerWidget extends ConsumerWidget {
  final Widget child;
  const NotificationListenerWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AppNotification?>(notificationProvider, (prev, next) {
      if (next == null) return;

      final color = switch (next.type) {
        NotificationType.success => Colors.green,
        NotificationType.error => Colors.red,
        _ => Colors.blue,
      };

      // OLD snackbar bo‘lsa yopib tashlaymiz
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(next.message),
          backgroundColor: color,
          duration: next.duration, // 🔥 MUHIM QISM
          behavior: SnackBarBehavior.floating,
        ),
      );

      // state’ni darhol tozalaymiz
      ref.read(notificationProvider.notifier).clear();
    });

    return child;
  }
}
