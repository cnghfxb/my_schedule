import 'package:flutter/material.dart';
import 'package:my_schedule/component/calendarEvent.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

/// Signs a user up with a username, password, and email. The required
/// attributes may be different depending on your app's configuration.

class _HomeState extends State<Home> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> kEvents = {};
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ??
        [
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈'),
          Event('哈哈')
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            return _getEventsForDay(day);
          }),
      const SizedBox(height: 8.0),
      Expanded(
        child: ValueListenableBuilder<List<Event>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    onTap: () => print('${value[index]}'),
                    title: Text('${value[index]}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]);
  }
}
