import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

class AddSechedule extends StatefulWidget {
  const AddSechedule({super.key});

  @override
  State<AddSechedule> createState() => _AddSecheduleState();
}

class _AddSecheduleState extends State<AddSechedule> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'zh_CN',
          firstDay: DateTime.utc(1970, 1, 1),
          lastDay: DateTime.utc(3000, 1, 1),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          calendarStyle: CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
          ),
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _calendarFormat = CalendarFormat.week;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
      ],
    );
  }
}
