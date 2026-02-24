import 'package:flutter/material.dart';
import 'top_notification.dart';

class NotificationProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;

  NotificationProvider(this.navigatorKey);

  void show(
      String message, {
        NotificationType type = NotificationType.info,
        Duration duration = const Duration(seconds: 2),
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
