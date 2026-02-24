import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpaceDateRangePicker extends StatefulWidget {
  final Function(DateTime? start, DateTime? end, int totalDays) onConfirm;
  final Function(DateTime? start, DateTime? end)? onChanged;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool disablePastDates; // O'tgan kunlarni bloklash

  const SpaceDateRangePicker({
    super.key,
    required this.onConfirm,
    this.onChanged,
    this.initialStartDate,
    this.initialEndDate,
    this.disablePastDates = true, // Standart holatda o'tgan kunlar bloklanadi
  });

  @override
  State<SpaceDateRangePicker> createState() => _SpaceDateRangePickerState();
}

class _SpaceDateRangePickerState extends State<SpaceDateRangePicker> {
  late DateTime _focusedDate;
  DateTime? _startDate;
  DateTime? _endDate;

  // Bugungi sanani soat/minutlarsiz toza holatda olish
  final DateTime _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    // Boshlang'ich sanalarni tozalab olamiz (faqat yil, oy, kun)
    _startDate = widget.initialStartDate != null ? _normalizeDate(widget.initialStartDate!) : null;
    _endDate = widget.initialEndDate != null ? _normalizeDate(widget.initialEndDate!) : null;

    // Kalendar qaysi oyni ko'rsatib turishi kerak
    _focusedDate = _startDate ?? DateTime(_today.year, _today.month, 1);
  }

  // Soat, minut, sekundlarni kesib tashlaydigan yordamchi metod
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Jami tanlangan kunlarni hisoblash
  int get _selectedDaysCount {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays + 1;
    }
    return _startDate != null ? 1 : 0;
  }

  // Header uchun chiroyli tekst (Masalan: 12 Okt - 15 Okt)
  String get _formattedRange {
    if (_startDate == null) return "Sana tanlang";
    if (_endDate == null) return DateFormat('dd MMM').format(_startDate!);
    return "${DateFormat('dd MMM').format(_startDate!)} - ${DateFormat('dd MMM').format(_endDate!)}";
  }

  void _clearSelection() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    if (widget.onChanged != null) widget.onChanged!(null, null);
  }

  void _onDateTap(DateTime date) {
    // Agar o'tgan kunlarni bloklash yoqilgan bo'lsa va sana bugundan oldin bo'lsa - hech narsa qilmaymiz
    if (widget.disablePastDates && date.isBefore(_today)) return;

    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        // Yangi tanlovni boshlash
        _startDate = date;
        _endDate = null;
      } else if (date.isBefore(_startDate!)) {
        // Agar foydalanuvchi boshlanish sanasidan oldingi sanani bossa, shuni boshlanish sanasi qilamiz
        _startDate = date;
        _endDate = null;
      } else if (date == _startDate) {
        // Xuddi shu kunni qayta bossa - 1 kunlik tanlov
        _endDate = date;
      } else {
        // Tugash sanasini belgilash
        _endDate = date;
      }
    });

    if (widget.onChanged != null) {
      widget.onChanged!(_startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(maxWidth: 380),
      decoration: BoxDecoration(
        color: const Color(0xFF161A33).withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 15),
          _buildWeekdayRow(),
          const SizedBox(height: 10),
          _buildCalendarGrid(),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 15),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white54, size: 18),
          onPressed: () => setState(() => _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1)),
        ),
        Column(
          children: [
            Text(
              DateFormat('MMMM yyyy').format(_focusedDate).toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            const SizedBox(height: 4),
            Text(
              _formattedRange,
              style: const TextStyle(color: Color(0xFF40E0D0), fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
          onPressed: () => setState(() => _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1)),
        ),
      ],
    );
  }

  Widget _buildWeekdayRow() {
    final days = ["Du", "Se", "Cho", "Pa", "Ju", "Sh", "Ya"];
    return Row(
      children: days.map((day) => Expanded(
        child: Center(
          child: Text(day, style: const TextStyle(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final daysInMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
    int firstWeekday = firstDayOfMonth.weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: firstWeekday + daysInMonth,
      itemBuilder: (context, index) {
        if (index < firstWeekday) return const SizedBox.shrink();

        final day = index - firstWeekday + 1;
        final date = DateTime(_focusedDate.year, _focusedDate.month, day);

        bool isToday = date == _today;
        bool isStart = _startDate != null && date == _startDate;
        bool isEnd = _endDate != null && date == _endDate;
        bool isInRange = _startDate != null && _endDate != null && date.isAfter(_startDate!) && date.isBefore(_endDate!);

        // O'tgan kunlarni tekshirish
        bool isPast = widget.disablePastDates && date.isBefore(_today);

        return GestureDetector(
          onTap: () => _onDateTap(date),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: (isStart || isEnd)
                  ? const Color(0xFF40E0D0)
                  : (isInRange ? const Color(0xFF40E0D0).withOpacity(0.15) : Colors.transparent),
              borderRadius: BorderRadius.circular(10),
              border: isToday && !isStart && !isEnd
                  ? Border.all(color: const Color(0xFF40E0D0).withOpacity(0.5), width: 1)
                  : null,
              boxShadow: (isStart || isEnd)
                  ? [BoxShadow(color: const Color(0xFF40E0D0).withOpacity(0.3), blurRadius: 8, spreadRadius: 1)]
                  : [],
            ),
            child: Center(
              child: Text(
                "$day",
                style: TextStyle(
                  // Agar o'tgan kun bo'lsa xira kulrang bo'ladi
                  color: isPast
                      ? Colors.white12
                      : (isStart || isEnd)
                      ? Colors.black
                      : (isToday ? const Color(0xFF40E0D0) : Colors.white70),
                  fontWeight: (isStart || isEnd || isToday) ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tozalash tugmasi
        InkWell(
          onTap: _clearSelection,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: const [
                Icon(Icons.refresh, color: Colors.white38, size: 16),
                SizedBox(width: 4),
                Text("Tozalash", style: TextStyle(color: Colors.white38, fontSize: 13)),
              ],
            ),
          ),
        ),

        // OK tugmasi
        InkWell(
          onTap: () {
            // Agar sana umuman tanlanmagan bo'lsa, xatolik bermasligi uchun tekshiramiz
            if (_startDate != null) {
              widget.onConfirm(_startDate, _endDate ?? _startDate, _selectedDaysCount);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _startDate == null
                    ? [Colors.grey.withOpacity(0.2), Colors.grey.withOpacity(0.2)] // O'chirilgan holat
                    : [const Color(0xFF2196F3), const Color(0xFF1565C0)], // Yoqilgan holat
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _startDate == null ? null : [BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 10)],
            ),
            child: Text(
              _startDate == null ? "Tanlang" : "OK (${_selectedDaysCount} kun)",
              style: TextStyle(
                  color: _startDate == null ? Colors.white38 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              ),
            ),
          ),
        ),
      ],
    );
  }
}