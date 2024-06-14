import 'package:flutter/material.dart';
import 'package:flutter_ai_project_alarm_clock/app/data/data.dart';
import 'package:flutter_ai_project_alarm_clock/app/data/enums.dart';
import 'package:flutter_ai_project_alarm_clock/app/data/models/menu_info.dart';
import 'package:flutter_ai_project_alarm_clock/app/data/theme_data.dart';
import 'package:flutter_ai_project_alarm_clock/app/modules/alarm_page.dart';
import 'package:flutter_ai_project_alarm_clock/app/modules/clock_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      body: Column(
        children: <Widget>[


          Expanded(
            child: Consumer<MenuInfo>(
              builder: (BuildContext context, MenuInfo value, Widget? child) {
                if (value.menuType == MenuType.clock)
                  return ClockPage();
                else if (value.menuType == MenuType.alarm)
                  return AlarmPage();
                else
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(text: 'new Page\n'),
                            TextSpan(
                              text: value.title,
                              style: TextStyle(fontSize: 48),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
              },
            ),
          ),
          Divider(
            color: CustomColors.dividerColor,
            height: 1,
          ),
          Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: menuItems.map((currentMenuInfo) => buildMenuButton(currentMenuInfo)).toList(),
           ),
        ],
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget? child) {
        return MaterialButton(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          color: currentMenuInfo.menuType == value.menuType ? CustomColors.menuBackgroundColor : CustomColors.pageBackgroundColor,
          onPressed: () {
            var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.updateMenu(currentMenuInfo);
          },
          child: Column(
            children: <Widget>[
              Image.asset(
                currentMenuInfo.imageSource!,
                scale: 1.5,

              ),
              const SizedBox(width: 16),
              Text(
                currentMenuInfo.title ?? '',
                style: TextStyle(fontFamily: 'avenir', color: CustomColors.seconderyTextColor, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}