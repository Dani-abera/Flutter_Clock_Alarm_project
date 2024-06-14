import 'package:flutter_ai_project_alarm_clock/app/data/enums.dart';
//import 'package:flutter_ai_project_alarm_clock/app/data/models/alarm_info.dart';
import 'package:flutter_ai_project_alarm_clock/app/data/models/menu_info.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock, title: 'Clock', imageSource: 'assets/icons8-clock-96.png'),
  MenuInfo(MenuType.alarm, title: 'Alarm', imageSource: 'assets/icons8-alarm-96.png'),
  MenuInfo(MenuType.timer, title: 'Timer', imageSource: 'assets/icons8-alarm-clock-100.png'),
  MenuInfo(MenuType.stopwatch, title: 'Stopwatch', imageSource: 'assets/icons8-timer-96.png'),
];

// List<AlarmInfo> alarms = [
//   AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 1)), title: 'Office', gradientColorIndex: 0),
//   AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 2)), title: 'Sport', gradientColorIndex: 1),
// ];