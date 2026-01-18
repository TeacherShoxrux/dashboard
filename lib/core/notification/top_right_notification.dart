import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_card.dart';
import 'notification_notifier.dart';
import 'app_notification.dart';

class TopRightNotificationListener extends ConsumerStatefulWidget {
  final Widget child;
  const TopRightNotificationListener({required this.child, super.key});

  @override
  ConsumerState<TopRightNotificationListener> createState() =>
      _TopRightNotificationListenerState();
}

class _TopRightNotificationListenerState
    extends ConsumerState<TopRightNotificationListener> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    ref.listen<AppNotification?>(notificationProvider, (prev, next) {
      if (next == null) return;

      _showOverlay(context, next);
      ref.read(notificationProvider.notifier).clear();
    });

    return Material(
        color: Colors.transparent,
        child: widget.child);
  }

  void _showOverlay(BuildContext context, AppNotification notification) {
    _overlayEntry?.remove();

    final overlay = Overlay.of(context, rootOverlay: true); // xavfsizlik

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: NotificationCard(notification),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    Timer(notification.duration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}
