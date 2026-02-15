import 'package:flutter/material.dart';
//
// class SpaceDateRangePicker extends StatefulWidget {
//   import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpaceDateRangePicker extends StatefulWidget {
  const SpaceDateRangePicker({super.key});

  @override
  State<SpaceDateRangePicker> createState() => _DynamicSpaceDatePickerState();
}

class _DynamicSpaceDatePickerState extends State<SpaceDateRangePicker> {
  DateTime _focusedDate = DateTime.now(); // Hozirgi ko'rinayotgan oy
  DateTime? _startDate;
  DateTime? _endDate;
  final DateTime _today = DateTime.now();

  // Oy nomini o'zbekcha formatda olish
  String get _monthYearText => DateFormat('MMMM yyyy').format(_focusedDate);

  // Tanlangan kunlar soni
  int get _selectedDaysCount {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays + 1;
    }
    return _startDate != null ? 1 : 0;
  }

  // Oy o'zgartirish funksiyalari
  void _prevMonth() => setState(
      () => _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1));
  void _nextMonth() => setState(
      () => _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1));

  void _onDateTap(DateTime date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
      } else if (date.isBefore(_startDate!)) {
        _startDate = date;
        _endDate = null;
      } else {
        _endDate = date;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 380), // Fullscreen bo'lmasligi uchun
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF161A33).withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // HEADER (Navigation)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white54, size: 18),
                    onPressed: _prevMonth,
                  ),
                  Text(
                    _monthYearText.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white54, size: 18),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // HAFTA KUNLARI
              _buildWeekdayRow(),
              const SizedBox(height: 10),

              // KALENDAR SETKASI
              _buildCalendarGrid(),

              const SizedBox(height: 20),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 15),

              // FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tanlandi:",
                          style:
                              TextStyle(color: Colors.white38, fontSize: 11)),
                      Text(
                        "$_selectedDaysCount kun",
                        style: const TextStyle(
                            color: Color(0xFF40E0D0),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  _buildOkButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekdayRow() {
    final days = ["Du", "Se", "Cho", "Pa", "Ju", "Sh", "Ya"];
    return Row(
      children: days
          .map((day) => Expanded(
                child: Center(
                    child: Text(day,
                        style: const TextStyle(
                            color: Colors.white24,
                            fontSize: 12,
                            fontWeight: FontWeight.bold))),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final daysInMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;

    // Du-Ya (1-7) formatiga moslash (O'zbekiston kalendari dushanbadan boshlanadi)
    int firstWeekday = firstDayOfMonth.weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      // Bo'sh kataklar + oy kunlari
      itemCount: firstWeekday + daysInMonth,
      itemBuilder: (context, index) {
        if (index < firstWeekday) return const SizedBox.shrink();

        final day = index - firstWeekday + 1;
        final date = DateTime(_focusedDate.year, _focusedDate.month, day);

        bool isToday = date.year == _today.year &&
            date.month == _today.month &&
            date.day == _today.day;
        bool isStart = _startDate != null && date == _startDate;
        bool isEnd = _endDate != null && date == _endDate;
        bool isInRange = _startDate != null &&
            _endDate != null &&
            date.isAfter(_startDate!) &&
            date.isBefore(_endDate!);

        return GestureDetector(
          onTap: () => _onDateTap(date),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: (isStart || isEnd)
                  ? const Color(0xFF40E0D0)
                  : (isInRange
                      ? const Color(0xFF40E0D0).withOpacity(0.15)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(10),
              border: isToday
                  ? Border.all(
                      color: const Color(0xFF40E0D0).withOpacity(0.5), width: 1)
                  : null,
              boxShadow: (isStart || isEnd)
                  ? [
                      BoxShadow(
                          color: const Color(0xFF40E0D0).withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1)
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                "$day",
                style: TextStyle(
                  color: (isStart || isEnd)
                      ? Colors.black
                      : (isToday ? const Color(0xFF40E0D0) : Colors.white70),
                  fontWeight: (isStart || isEnd || isToday)
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOkButton() {
    return InkWell(
      onTap: (){
        // Navigator.pop(context, [_startDate, _endDate])
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1565C0)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 10)
          ],
        ),
        child: const Text("OK",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
