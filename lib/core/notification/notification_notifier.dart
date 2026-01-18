import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_notification.dart';

class NotificationNotifier extends Notifier<AppNotification?> {
  @override
  AppNotification? build() => null;

  void show(AppNotification notification) {
    state = notification;
  }

  void clear() {
    state = null;
  }
}

final notificationProvider =
NotifierProvider<NotificationNotifier, AppNotification?>(
  NotificationNotifier.new,
);
