import 'package:flutter/material.dart';

enum NotificationType {
  success,
  error,
  info,
}

extension NotificationTypeX on NotificationType {
  Color get color {
    switch (this) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.info:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.info:
        return Icons.info;
    }
  }
}
class TopNotification extends StatefulWidget {
  final String message;
  final NotificationType type;
  final Duration duration;
  final bool fromRight;

  const TopNotification({
    super.key,
    required this.message,
    required this.type,
    required this.duration,
    this.fromRight = true,
  });

  @override
  State<TopNotification> createState() => _TopNotificationState();
}

class _TopNotificationState extends State<TopNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slide;
  late Animation<double> fade;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    slide = Tween<Offset>(
      begin: Offset(widget.fromRight ? 1 : -1, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    fade = Tween<double>(begin: 0, end: 1).animate(controller);

    controller.forward();

    Future.delayed(widget.duration, () async {
      await controller.reverse();
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.type.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.type.icon, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
