import 'package:admin/features/rent/renta_proccess.dart';
import 'package:flutter/material.dart';

import 'equipment_search.dart';

class CalendarSidePanel extends StatelessWidget {
  const CalendarSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
      
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E).withOpacity(0.9), // To'q binafsha fon
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EquipmentSearchWidget(),
      
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 10),
      
            RentalProcessWidget()
          ],
        ),
      ),
    );
  }
}