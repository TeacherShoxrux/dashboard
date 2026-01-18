import 'package:flutter/material.dart';
import 'top_notification.dart';

class NotificationService {
  final GlobalKey<NavigatorState> navigatorKey;

  NotificationService(this.navigatorKey);

  void show(
      String message, {
        NotificationType type = NotificationType.info,
        Duration duration = const Duration(seconds: 3),
        bool fromRight = true,
      }) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (_, __, ___) {
        return TopNotification(
          message: message,
          type: type,
          duration: duration,
          fromRight: fromRight,
        );
      },
    );
  }
}
