import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_service.dart';

final rootNavigatorKeyProvider =
Provider<GlobalKey<NavigatorState>>(
      (ref) => GlobalKey<NavigatorState>(),
);

final notificationServiceProvider =
Provider<NotificationService>((ref) {
  return NotificationService(ref.watch(rootNavigatorKeyProvider));
});
