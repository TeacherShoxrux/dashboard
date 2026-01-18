enum NotificationType { success, error, info }

class AppNotification {
  final String message;
  final NotificationType type;
  final Duration duration;

  AppNotification(
      this.message,
      this.type, {
        this.duration = const Duration(seconds: 3), // ⏱ default
      });
}

