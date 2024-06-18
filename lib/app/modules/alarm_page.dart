//import 'dart:js_interop_unsafe';

import 'package:flutter_ai_project_alarm_clock/alarm_helper.dart';
import 'package:flutter_ai_project_alarm_clock/app/data/theme_data.dart';
import 'package:flutter_ai_project_alarm_clock/app/data/models/alarm_info.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_ai_project_alarm_clock/main.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  late String _alarmTimeString;
  bool _isRepeatSelected = false;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('******** database initialized ********');

      loadAlarms();

    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Alarm',
            style:
            TextStyle(fontFamily: 'avenir', fontWeight: FontWeight.w700, color: CustomColors.primaryTextColor, fontSize: 24),
          ),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;
                  return ListView(
                    children: snapshot.data!.map<Widget>((alarm) {
                      var alarmTime = DateFormat('hh:mm aa').format(alarm.alarmDateTime!);
                      var gradientColor = GradientTemplate.gradientTemplate[alarm.gradientColorIndex!].colors;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColor,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradientColor.last.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(4, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.label,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      alarm.title!,
                                      style: const TextStyle(color: Colors.white, fontFamily: 'avenir'),
                                    ),
                                  ],
                                ),
                                Switch(
                                  onChanged: (bool value) {},
                                  value: true,
                                  activeColor: Colors.white,
                                ),
                              ],
                            ),
                            const Text(
                              'Mon-Fri',
                              style: TextStyle(color: Colors.white, fontFamily: 'avenir'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  alarmTime,
                                  style: const TextStyle(
                                      color: Colors.white, fontFamily: 'avenir', fontSize: 24, fontWeight: FontWeight.w700),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                    onPressed: () {
                                      deleteAlarm(alarm.id);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).followedBy([
                      if (_currentAlarms!.length < 5)
                        DottedBorder(
                          strokeWidth: 2,
                          color: CustomColors.clockOutline,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(24),
                          dashPattern: [5, 4],
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.clockBG,
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                            ),
                            child: MaterialButton(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Container(
                                          padding: const EdgeInsets.all(32),
                                          child: Column(
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  var selectedTime = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.now(),
                                                  );
                                                  if (selectedTime != null) {
                                                    final now = DateTime.now();
                                                    var selectedDateTime = DateTime(
                                                        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
                                                    _alarmTime = selectedDateTime;
                                                    setModalState(() {
                                                      _alarmTimeString = DateFormat('h:mm a').format(selectedDateTime);
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  _alarmTimeString,
                                                  style: const TextStyle(fontSize: 32),
                                                ),
                                              ),
                                              ListTile(
                                                title: const Text('Repeat'),
                                                trailing: Switch(
                                                  onChanged: (value) {
                                                    setModalState(() {
                                                      _isRepeatSelected = value;
                                                    });
                                                  },
                                                  value: _isRepeatSelected,
                                                ),
                                              ),
                                              const ListTile(
                                                title: Text('Sound'),
                                                trailing: Icon(Icons.arrow_forward_ios),
                                              ),
                                              const ListTile(
                                                title: Text('Title'),
                                                trailing: Icon(Icons.arrow_forward_ios),
                                              ),
                                              FloatingActionButton.extended(
                                                onPressed: () {
                                                  onSaveAlarm(_isRepeatSelected);
                                                },
                                                icon: Icon(Icons.alarm),
                                                label: Text('Save'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                                // scheduleAlarm();
                              },
                              child: const Column(
                                children: <Widget>[
                                  Icon(Icons.add_alarm, size: 54.0,),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add Alarm',
                                    style: TextStyle(color: Colors.white, fontFamily: 'avenir'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        const Center(
                            child: Text(
                              'Only 5 alarms allowed!',
                              style: TextStyle(color: Colors.white),
                            )),
                    ]).toList(),
                  );
                }
                return const Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void scheduleAlarm(DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo, {required bool isRepeating}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: '@mipmap/ic_launcher',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (isRepeating) {
      (
        0,
        'Office',
        alarmInfo.title,
        (
          scheduledNotificationDateTime.hour,
          scheduledNotificationDateTime.minute,
          scheduledNotificationDateTime.second,
        ),
        platformChannelSpecifics,
      );
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Office',
        alarmInfo.title,
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  void onSaveAlarm(bool _isRepeating) {
    DateTime? scheduleAlarmDateTime;
    if (_alarmTime!.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime;
    else
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: 'alarm',
    );
    _alarmHelper.insertAlarm(alarmInfo);
    if (scheduleAlarmDateTime != null) {
      scheduleAlarm(scheduleAlarmDateTime, alarmInfo, isRepeating: _isRepeating);
    }
    Navigator.pop(context);
    loadAlarms();
  }

  void deleteAlarm(int? id) {
    _alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }
}