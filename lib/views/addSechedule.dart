import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/getwidget.dart';
import 'package:my_schedule/utils/api/api.dart';
import 'package:my_schedule/utils/theme/colorTheme.dart';
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
  List<Map<String, dynamic>> _scheduleTypeOptions = [];
  int _scheduleType = 1;

  List<GFRadioListTile> _scheduleTypeOptionsRander() {
    if (_scheduleTypeOptions.length == 0) {
      return [];
    }
    List<GFRadioListTile> list = [];
    for (var i = 0; i < _scheduleTypeOptions.length; i++) {
      list.add(GFRadioListTile(
          title: Text(_scheduleTypeOptions[i]['label']),
          size: GFSize.MEDIUM,
          activeBorderColor: primary,
          inactiveIcon: null,
          radioColor: primary,
          value: _scheduleTypeOptions[i]['value'],
          groupValue: _scheduleType,
          onChanged: (val) {
            setState(() {
              _scheduleType = val;
            });
          }));
    }
    return list;
  }

  Future<void> _getScheduleTypeOptions() async {
    try {
      EasyLoading.show(status: 'loading...');
      final list = await getScheduleTypes();
      List<Map<String, dynamic>> newList = [];
      for (var i = 0; i < list.length; i++) {
        Map<String, dynamic> map = {};
        map['value'] = list[i]['id'];
        map['label'] = list[i]['typeName'];
        newList.add(map);
      }
      setState(() {
        _scheduleTypeOptions = newList;
      });
    } catch (err) {
      print(err);
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    _getScheduleTypeOptions();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
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
            Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                child: Text(
                  '类型',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Column(
              children: _scheduleTypeOptionsRander(),
            )
          ],
        ),
      ),
    );
  }
}
