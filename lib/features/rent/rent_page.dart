import 'package:admin/features/rent/side.dart';
import 'package:flutter/material.dart';
import '../main_layout/date_range_picker.dart';
import 'customer_search.dart';
import 'equipment_search.dart';

class RentPage extends StatefulWidget {
  const RentPage({super.key});
  @override
  State<RentPage> createState() => _RentFormPageState();
}
class Client {
  final String name, surname, passport, license;
  Client(this.name, this.surname, this.passport, this.license);
  @override
  String toString() => '$name $surname';
}

class Machine {
  final String category, imageUrl, price;
  final int count;
  Machine(this.category, this.imageUrl, this.count, this.price);
}

class _RentFormPageState extends State<RentPage> {
  Client? selectedClient;
  List<Machine> selectedMachines = [];
  DateTimeRange? selectedDateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 19)));
  TimeOfDay startTime = const TimeOfDay(hour: 09, minute: 00);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 00);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery
        .of(context)
        .size
        .width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      // appBar: AppBar(title: const Text("Ijaraga berish"), backgroundColor: Colors.transparent),
      body: isMobile
          ? Column(children: [
        _mainContent(),
        const SizedBox(height: 20),
        CalendarSidePanel()
      ])
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 1, child: _mainContent()),
        const SizedBox(width: 20),
        Expanded(flex: 2, child: CalendarSidePanel()),
      ]),
      // bottomNavigationBar: _buildRentButton(),
    );
  }
  Widget _mainContent() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        AdvancedCustomerSearch(),
        SpaceDateRangePicker(onConfirm: (DateTime? start, DateTime? end, int totalDays) {
          print(start);
          print(end);
          print(totalDays);
        },)
      ]),
    );
  }


}