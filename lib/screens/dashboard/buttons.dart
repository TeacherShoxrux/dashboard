import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onRent;
  final VoidCallback onBooking;

  const ActionButtons({
    super.key,
    required this.onRent,
    required this.onBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. BAND QILISH TUGMASI (Booking)
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onBooking,
            icon: const Icon(Icons.calendar_month_outlined, size: 20),
            label: const Text("BAND QILISH"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange[800],
              side: BorderSide(color: Colors.orange[800]!),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 2. IJARAGA BERISH TUGMASI (Rent)
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onRent,
            icon: const Icon(Icons.key, size: 20),
            label: const Text("IJARAGA BERISH"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}