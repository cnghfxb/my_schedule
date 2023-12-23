import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:my_schedule/store/secheduleAdd.dart';
import 'package:my_schedule/utils/api/api.dart';
import 'package:my_schedule/utils/theme/colorTheme.dart';
import 'package:table_calendar/table_calendar.dart';

class AddSechedule extends StatefulWidget {
  const AddSechedule({super.key});

  @override
  State<AddSechedule> createState() => _AddSecheduleState();
}

class _AddSecheduleState extends State<AddSechedule> {
  ScheduleAddController scheduleAddController =
      Get.put<ScheduleAddController>(ScheduleAddController());

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  Map<int, dynamic> _scheduleTypeKV = {1: '日程'};
  int _scheduleType = 1;

  List<GFRadioListTile> _scheduleTypeOptionsRander() {
    // ignore: invalid_use_of_protected_member
    if (scheduleAddController.typeOptions.value.length == 0) {
      return [];
    }
    List<GFRadioListTile> list = [];
    for (var i = 0; i < scheduleAddController.typeOptions.length; i++) {
      list.add(GFRadioListTile(
          title: Text(scheduleAddController.typeOptions[i]['label']),
          size: GFSize.SMALL,
          activeBorderColor: primary,
          inactiveIcon: null,
          radioColor: primary,
          value: scheduleAddController.typeOptions[i]['value'],
          groupValue: _scheduleType,
          onChanged: (val) {
            print(scheduleAddController.typeOptions);
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
        _scheduleTypeKV[list[i]['id']] = list[i]['typeName'];
      }
      scheduleAddController.setTypeOptions(newList);
    } catch (err) {
      print(err);
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    if (scheduleAddController.typeOptions.length == 0) {
      _getScheduleTypeOptions();
    }
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
              child: ExpandablePanel(
                header: Text('选择类型'),
                collapsed: Text(_scheduleTypeKV[_scheduleType]),
                expanded: Obx(() => Column(
                      children: _scheduleTypeOptionsRander(),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
